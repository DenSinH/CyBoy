with open("files/logdiff/trace.log", "r") as f:
    with open("files/logdiff/true.log", "r") as g:
        while True:
            mine = f.readline()
            true = g.readline()
            if not true.startswith(mine.strip()):
                print(mine)
                print(true)
                input()
print("no diff")