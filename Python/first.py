import sys

instance_type = sys.argv[1]

if instance_type == "t2.micro":
    print(f"OK, we will create an instance for {instance_type}")
else:
    print("this is not")
