import csv
from subprocess import Popen
import os
from datetime import datetime, UTC

# Params
repo_name = "project_x"
directory = f"archive-{repo_name}"

# Create the logfile with
# git log --authors="<name>" --all --pretty=format:"%at;%s" > <repo_name>.log
log_file = f"../logs/{repo_name}.log"


def run(commands):
    Popen(commands).wait()


# Create repository
os.mkdir(directory)
os.chdir(directory)
run(["git", "init", "-b", "main"])

with open(log_file, newline="") as csvfile:
    reader = csv.reader(csvfile, delimiter=";")
    for row in reader:
        timestamp = int(row[0])
        subject = row[1]
        datestr = datetime.fromtimestamp(timestamp, UTC).strftime('"%Y-%m-%d %H:%M:%S"')

        # git add .
        # git commit -m subject --date datestr
        print('git commit -m "%s" --date "%s"' % (subject, datestr))

        with open(os.path.join(os.getcwd(), "README.md"), "a") as readme_file:
            readme_file.write(datestr + " - " + subject + "\n\n")

        run(["git", "add", "."])
        run(
            [
                "git",
                "commit",
                "-m",
                '"%s"' % subject,
                "--date",
                datestr,
            ]
        )

print(
    f"""
    Repository {directory} was created. To upload to github, run:

    $ git remote add origin <github_url>
    $ git branch -M main
    $ git push -u origin main
"""
)
