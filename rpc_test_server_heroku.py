import traceback
import io
import os

has_errors = False


# path to lua files
path = "Game\\scripts\\vscripts\\"


# key - data to find
# value - data to replace
dataToChange = {
	"ROSHPIT_URL = \"https://roshpit.herokuapp.com\"": "ROSHPIT_URL = \"https://roshpit-test.herokuapp.com\"",
	"GetDedicatedServerKeyV2(SaveLoad.KeyVersion)": "\"test\"",
	"function SaveLoad:GetAllowSaving()": "function SaveLoad:GetAllowSaving() return true end function SaveLoad:GetAllowSavingOld()",
}


# files with any of "dataToChange" keys 
filesToEdit = {}


# find all files and append them into "filesToEdit"
def find_files():
	for filePath in files:
		print()
		print("[find_files] " + filePath)
		with io.open(filePath, encoding='utf-8') as file:
			Lines = file.readlines()
			for i,line in enumerate(Lines, 1):
				# print(line)
				if any(ext in line for ext in dataToChange.keys()):
					print("Found: " + filePath)
					print(line)
					print()
					filesToEdit[filePath] = line
					break


# replacing lines with "dataToChange" pattern, "key" would be replaced by it "value"
def edit_file(fPath):
	print()
	print()
	print("[edit_files] " + fPath)
	# resFuncDict = {}
	toWrite = []
	with io.open(fPath, encoding='utf-8') as file:
		Lines = file.readlines()
		for i,line in enumerate(Lines, 1):
			newline = line
			for k,v in dataToChange.items():
				if k in newline:
					newline = newline.replace(k, v)
					print(newline)
			# print(line)
			
			toWrite.append(newline)
	with io.open(fPath, 'w', encoding='utf-8') as wFile:
		wFile.writelines(toWrite)


# Finding all ".lua" files in "path" and subfolders
files = []
# r=root, d=directories, f = files
for r, d, f in os.walk(path):
	for file in f:
		if '.lua' in file:
			files.append(os.path.join(r, file))

find_files()

for f in filesToEdit.keys():
	print(f)
	edit_file(f)




print()
print()
if has_errors:
	input("Err, check log.")
else:
	input("! OK ! Press enter to exit.")