import sys
import re
import math
import subprocess
import platform

cdef dict token
cdef list CONSTANTS
cdef str code

title = """
███████████████████████████████             █▄─▀─▄█▄─▄▄─█─▄▄▄─█▄─▄▄─█─▄▄▄▄█
██▀─▀███─▄█▀█─███▀██─▄█▀█▄▄▄▄─█
▀▄▄█▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀

Xeces 0.0.1 (April 1 2022, 15:08:09)        For "contributions", "help", "copyright", "credits" or "license" visit "https://github.com/moriire/xeces" for more information.


"""

token = {
"is": "==", 
"is-equal":"=",  
"is-not-equal":"!=",
"is-greater-than":">",
"is-less-than":"<",
"is-equal-less-than":"=<",
"is-equal-greater-than":"=>",
"plus": "+", 
"minus": "-",
"times":"*",
"divide": "/",
"power": "**"
 }

CONSTANTS = dir(math)
class Xeces:

    @staticmethod
    def parser(code):
        cdef int a, z, pos, length, p1, p2
        cdef str fcode, f0, f1, p3, stcode
        stcode = ""
        tok = re.match(r"^:.*:$", code)
        if tok:
            a, z = tok.span()
            fcode = code[a+1:z-1]
            fc = fcode.strip().split(" ")
            length = len(fc)
            pos = 0
            while pos < length:
                if fc[pos] in CONSTANTS:
                    const = ""
                    try:
                        f0, f1 = fc[pos], fc[pos+1]
                        y = re.match(r"^`.*`$", f1)
                        p1, p2 = y.span()
                        p3 = f1[(p1+1):(p2-1)]
                        if p3.isdigit():
                            const = eval(f"math.{f0}({p3})")
                            if p3 in CONSTANTS:
                                const = eval(f"math.{f0}(math.{p3})")

                    except IndexError:
                        const = eval(f"math.{fc[pos]}")
                    finally:
                        stcode += str(const)
                        pos += 1
                elif (fc[pos]).isdigit():
                    stcode += fc[pos]
                    pos += 1
                elif fc[pos] in token:
                    stcode += token[fc[pos]]
                    pos += 1
                else:
                    break
            return eval(stcode)
        else:
            return "Wrong xeces syntax"

    def interpreter(self):
        print(title)
        while True:
            try:
                line = input(">> ")
                code = self.parser(line)
                print(code)
            except KeyboardInterrupt:
                print("Exited xeces...")
                sys.exit(0)
            except:
                print("Invalid Syntax:Something went wrong")
                continue

    def __call__(self):
        pf = platform.system()
        if pf == "Linux":
            command = subprocess.run(["which", "python"])
            if command.returncode == 1:
                subprocess.run("pkg install python".split(" "))
            else:
                subprocess.run(["python", "pxhll.py"])
                pexists = command.stdout
                print(pexists)
            self.interpreter()

    def run(self):
        return self()

