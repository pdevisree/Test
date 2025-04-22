import os

folders = input("please provide a number:").split()

for folder in folders:

    try:
       files = os.listdir(folder)
    except FileNotFoundError:
       print("please provide a valid folder name, looks like folder does not exist:" + folder)
       break
    except PermissionError:
       break
       print("No access to folder:" + folder)

       print("=== listing files for the folder-" + folder)

    for file in files:
        print(file)
