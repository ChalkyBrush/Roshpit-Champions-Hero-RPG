import traceback
import io

has_errors = False

filesToCheck = [
  "Game\\scripts\\vscripts\\challenges.lua", 
  "Game\\scripts\\vscripts\\events.lua", 
  "Game\\scripts\\vscripts\\items.lua", 
  "Game\\scripts\\vscripts\\glyphs.lua",
  "Game\\scripts\\vscripts\\game_state.lua",
  "Game\\scripts\\vscripts\\stars.lua",
  "Game\\scripts\\vscripts\\items\\RPCamulet.lua", 
  "Game\\scripts\\vscripts\\items\\legendaries.lua", 
  "Game\\scripts\\vscripts\\items\\special_item_effects.lua", 
]
resourceFile = "rpc_test_server_resources.txt"

def build_test():
	global has_errors
	for f in filesToCheck:
		print()
		print()
		if not has_errors:
			try:
				print("File: " + f)
				print()
				edit_file(f)        
			except Exception as e:
				has_errors = True
				traceback.print_exc()
				#print(e)
		else:
			break

def edit_file(fPath):
	resFuncDict = {}
	toWriteFuncDict = []
	with io.open(resourceFile, encoding='utf-8') as resFile:
		resLines = resFile.readlines()
		for i,line in enumerate(resLines, 1):
			if line.startswith("function "):
				#print(str(i) + " line: " + line)
				resFuncDict[line] = get_function(resourceFile, line)
	with io.open(fPath, encoding='utf-8') as readFile:
		readLines = readFile.readlines()
		for i,line in enumerate(readLines):
			if line.startswith("function "):
				if line in resFuncDict:
					toWriteFuncDict.append(line)
					print("Found: " + line)
					nextLine = i
					while not readLines[nextLine].startswith("end"):
						readLines[nextLine] = comment_or_remove(readLines[nextLine], False)
						nextLine = nextLine + 1
						#print(str(nextLine) + " line edited")
					readLines[nextLine] = comment_or_remove(readLines[nextLine], False)
	with io.open(fPath, 'w', encoding='utf-8') as wFile:
		wFile.write("\n")
		wFile.writelines(readLines)
		for key,value in resFuncDict.items():
			if fPath == "Game\\scripts\\vscripts\\events.lua":
				if "function StringSplit(inputstr, sep)" in key or "function LoadCharacterDev(playerID, slot, steamID)" in key or "function ChatDropItems(keys)" in key or "function ChatDropWep(str, vector, text)"in key:
					wFile.write("\n")
					wFile.write("\n")
					wFile.writelines(value)
			if key in toWriteFuncDict:
				wFile.write("\n")
				wFile.write("\n")
				wFile.writelines(value)

def comment_or_remove(line, comment):
	if comment == True:
		return "--" + line
	else:
		return ""

def get_function(path, functionName):
	function = []
	with io.open(path, encoding='utf-8') as file:
		readLines = file.readlines()
		functionFound = False
		for i,line in enumerate(readLines, 1):
			if line.startswith(functionName):
				if functionFound:
					input("Can't find function code, another function inside.")
					break
				functionFound = True
				function.append(line)
				continue
			if functionFound:
				if line.startswith("end"):
					function.append(line)
					return function
				else:
					function.append(line)
		

build_test()
print()
print()
if has_errors:
	input("Err, check log.")
else:
	input("! OK ! Press enter to exit.")