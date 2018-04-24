#!/usr/bin/python
#20170322 loryu
from random import choice
import string
class password_generator:
	def pwdgen(len=16):
		symfield = ['\~','\!','\@','\#','\%','\^','\*','\(','\)','\_','\+','\-','\=','\,','\.','\?','\/','\<','\>']
		numfield = []
		for i in range(10):
			numfiled = numfield.append(str(i))
		chrfieldupper = [chr(i) for i in range(65,91)]
		chrfieldlower = [chr(i) for i in range(97,123)]
		chrfield = chrfieldlower + chrfieldupper
		pwd_source = symfield + numfield + chrfield
		return ''.join([choice(pwd_source) for i in range(len)])
	if __name__ == "__main__":
		pwd_len=input("how long password will generate:")
		amt=raw_input("Enter how many password to generate:")
		for i in range(int(amt)):
			print (pwdgen(pwd_len))
