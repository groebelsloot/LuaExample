# LuaExample

---
This is the Lua example in Haxe as explained in our Groebelsloot blog post: http://www.groebelsloot.com/2016/10/17/adding-gameplay-logic-using-lua/
This example works with the Haxe cpp target only.
---

### Example usage

First you need the hx-lua library. I used the version by RudenkoArts: https://github.com/RudenkoArts/hx-lua

This is not a Haxelib libary, so you have to install it manually:

First, clone the hx-lua using git. I cloned it in my D:\GIT folder:

So in my D:\GIT\ I did: git clone https://github.com/RudenkoArts/hx-lua.git
This will create a 'hx-lua' folder
Then you have to rebuild some ndll files:
cd hx-lua
cd project

If you have flow installed:
flow build lua windows --clean

If you have lime installed:
lime rebuild lua windows -clean

Now the libraries are up to date for the windows build (if you use mac then you obviously should use 'mac' as the buid target)

Because this lib is not installed using Haxelib, we have to point Haxelib to he correct library:
haxelib dev lua [dir-you-installed-hx-lua]
So in my case: haxelib dev lua d:\git\hx-lua

Now you can try this example by going to the directory of the example and run:
haxe build.hxml

This will compile, build and run the example.

This build.hxml probably only works on Windows, because it assumes a Main.exe is created. You can delete the last line in build.hxml when you use other targets.

```
