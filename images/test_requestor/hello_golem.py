import os
import json
import asyncio
import subprocess
from time import sleep
from typing import AsyncIterable

from yapapi import Golem, Task, WorkContext
from yapapi.log import enable_default_logger
from yapapi.payload import vm

greeting = "\nHello from Golem!"

async def worker(context: WorkContext, tasks: AsyncIterable[Task]):
    async for task in tasks:
        script = context.new_script()
        future_result = script.run("/bin/echo", greeting)

        yield script

        task.accept_result(result=await future_result)


async def main():
    package = await vm.repo(
        image_hash="d646d7b93083d817846c2ae5c62c72ca0507782385a2e29291a3d376", # from Hello World Task example in docs
    )

    tasks = [Task(data=None)]

    async with Golem(budget=1.0, subnet_tag="public") as golem:
        async for completed in golem.execute_tasks(worker, tasks, payload=package):
            print(completed.result.stdout)


if __name__ == "__main__":

    enable_default_logger(log_file="hello.log")

        # Set app key
    while os.getenv('YAGNA_APPKEY') is None:
        key_list = subprocess.run(["yagna", "app-key", "list", "--json"], capture_output=True)
        os.environ['YAGNA_APPKEY'] = json.loads(key_list.stdout)[0].get('key')
        sleep(5)

    loop = asyncio.get_event_loop()
    task = loop.create_task(main())
    loop.run_until_complete(task)
