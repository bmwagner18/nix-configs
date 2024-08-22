import yaml
import argparse
import subprocess
import os

# Parse input to determine which frequency list to use
parser = argparse.ArgumentParser()
# -f FREQUENCY (HOURLY, DAILY, WEEKLY)
parser.add_argument("-f", "--frequency", help="HOURLY DAILY or WEEKLY")
# -p PATH-TO-YAML
parser.add_argument("-p", "--path", help="path to config yaml")
args = parser.parse_args()

# Open the configuration yaml file and parse inputs
try:
  with open(args.path, 'r') as stream:
      try: backups = yaml.safe_load(stream)
      except yaml.YAMLError as e: print(e)
except: print("Path to yaml invalid")

backup_dir = backups["backup_dir"]
if backup_dir[-1] != "/": backup_dir=backup_dir+"/"

user = backups["user"]

# Select correct frequency list based on command args
if args.frequency == "HOURLY": current_backup = backups['hourly']
elif args.frequency == "DAILY": current_backup = backups['daily']
elif args.frequency == "WEEKLY": current_backup = backups['weekly']
else:
    print("Valid input for -f (HOURLY DAILY or WEEKLY) is required!")
    quit()

if current_backup is None:
    print("No backups were selected in yaml")
    exit()

for system in current_backup:
    backup_location = backup_dir + system
    if current_backup[system] is None:
        print("No backups were selected for %s in yaml" % (system))
        continue
    for location in current_backup[system]:
        backup_location = backup_dir + system + location
        command_list = ["rdiff-backup", "--remove-older-than", "50B", "--api-version", "201", "backup", "--create-full-path"]
        if isinstance(current_backup[system], dict):
            includes = current_backup[system][location].get("include")
            excludes = current_backup[system][location].get("exclude")
            if includes is not None and includes != "":
                command_list.extend(["--include", includes])
            if excludes is not None and includes != "":
                command_list.extend(["--exclude", excludes])
        command_list.append("%s@%s::%s" % (user, system, location))
        command_list.append(backup_location)

        print(command_list)
        subprocess.run(command_list)
