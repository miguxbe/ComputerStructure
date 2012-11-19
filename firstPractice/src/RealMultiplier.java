package firstPractice;

import java.util.Scanner;

/**
 * Exercise4 class
 * @version 1
 * @author Adrian Mª Mora Carreto NIA: 100291775
 * @author Ramses Joel Salas Machado NIA:100292149
 */

public class RealMultiplier{
	
	public static void main(String [] args){
		
		Scanner sc = new Scanner(System.in);
		System.out.println("Introduce the first number:");
		try {
			float number1 = sc.nextFloat();
			System.out.println("introduce the second number:");
			float number2 = sc.nextFloat();
			System.out.println("result:" + floatMultiplier(number1,number2));
		} catch (Exception e){
			System.out.println("NaN");
			System.exit(-1);
		}
	}

	/**
	 * This method multiplies two float numbers, converting them first into IEEE 754 format in order to
	 * simplify the multiplication
	 * @see createMantissa(String);
	 * @param num1 First number to multiply
	 * @param num2 Second number to multiply
	 * @return sign + " " + expAddition + " " + createMantissa(multiplication) The number in IEEE 754 format
	 */
	public static String floatMultiplier(float num1, float num2){

		String ieee1=floatToIEEE754(num1);
		System.out.println("The number " + num1 + " in IEEE754 is " + ieee1);
		String ieee2=floatToIEEE754(num2);
		System.out.println("The number " + num2 + " in IEEE754 is " + ieee2);
		String expAddition="",normalized="1.";
		int e=0,position=0;
		
		//We get the signs and compare them
		String sign="" + (ieee1.charAt(0)^ieee2.charAt(0));

		//We multiply the mantissa with the implicit bit and normalizing it
		String multiplication=binaryMultiplier(("1."+ieee1.substring(11, 23)),"1."+ieee2.substring(11, 23));
		//If the first number is different of '1' we look for the position 
		//of the first '1' in the string of characters and we add -1 for each character to the exponent
		if(multiplication.charAt(0)!='1'){
			//Because we begin in the second position
			e=-1;
			for(int i=2;i<=multiplication.length()-1;i++){
				if (multiplication.charAt(i)=='1'){
					position=i;
					break;
				}
				e-=1;
			}
			//Now we add each of the character after the 1 that we found in the previous loop
			for(int i=position;i<=multiplication.length()-1;i++){
				//If the pointer is in the last character add '0' to the string if the comma
				//is the previous symbol
				if(i==(multiplication.length()-1)) {
					if(normalized.charAt(normalized.length()-1)=='.')normalized+='0';
				}
				else {
					normalized+=multiplication.charAt(i+1);
				}
			}
		} //We look for the comma and add 1 to the exponent for every character that it's not 
		else {
			for(int i=1;i<multiplication.length()-1;i++){
				if(multiplication.charAt(i)=='.'){
					break;
				}
				e+=1;
			}
			//We form the string normalized
			for(int i=1;i<=multiplication.length()-1;i++){
				if(multiplication.charAt(i)!='.') normalized+=multiplication.charAt(i);
			}
		}

		//We obtain the exponents
		String exp1=ieee1.substring(2,10);
		String exp2=ieee2.substring(2,10);
		//we add the exponents and subtracting the bias
		//If the normalize exponent is bigger than 0 we add it to the sum of the exponents
		if(e>0){
			expAddition=addBinary(subBinary(addBinary(exp1,exp2),integerToBinary(127)),integerToBinary(e));
		}//If the normalize exponent is smaller than 0 we subtract it to the sum of the exponents
		else if(e<0){
			expAddition=subBinary(subBinary(addBinary(exp1,exp2),integerToBinary(127)),integerToBinary(e));
		} // If the normalize exponent is 0 then we substract the addition of the exponents and 127
		else{
			expAddition=subBinary(addBinary(exp1,exp2),integerToBinary(127));
		}
		
		//Add 0 to the left if there aren't 8 characters
		while(expAddition.length()<8) expAddition= '0'+ expAddition;
		//If the string has one or more zeros, eliminate them
		while(expAddition.length()>8 & expAddition.charAt(0)=='0') expAddition=expAddition.substring(1);

		// Finally, we calculate the mantissa with the createMantissa method.
		return sign + " " + expAddition + " " + createMantissa(normalized);
	}
	
	/**
	 * This method multiply two binary numbers
	 * @param num1 First binary number
	 * @param num2 Second binary number
	 * @return result The result of the multiplication
	 */
	public static String binaryMultiplier(String num1,String num2){
		String result = "";
		String number1 = "",number2 = "";
		int exponent = 0;
		// First we check if the numbers have a decimal value or not, in order to put the decimal value after the multiplication
		if(num1.contains(".")){
			exponent += (num1.length()-1 - num1.indexOf('.'));
		}
		if(num2.contains(".")){
			exponent += (num2.length()-1 - num2.indexOf('.'));
		}
		// It is more efficient if we multiply the numbers not taking into account the period, so we convert the arguments
		for (int i=0;i<num1.length();i++){
			if (num1.charAt(i)!='.') number1 += num1.charAt(i);
		}
		for (int i=0;i<num2.length();i++){
			if (num2.charAt(i)!='.') number2 += num2.charAt(i);
		}
		// The multiplication is as follows: the result is the addition of the result and the multiplication.
		String multiplication = "";
		for (int i=number2.length()-1;i>=0;i--){
			// If the position of the second number is 1 then we obtain that the multiplication now is the first number
			if (number2.charAt(i)=='1'){
				multiplication = number1;
				// But we have to add as many 0 to the right as positions from right to left we are
				int temp = number2.length()-1;
				while (temp != i){
					multiplication = multiplication + "0";
					temp--;
				}
				// Finally we add both results
				result = addBinary(result,multiplication);
			}
		}
		// And now we put the period in the result
		if(num1.contains(".") | num2.contains(".")){
			String real = result.substring(0,result.length()-exponent);
			String decimal = result.substring(result.length()-exponent);
			result = real.concat(".").concat(decimal);
		}
		return result;
	}
	
	/**
	 * This method subtract two binary numbers
	 * @param number1 Minued
	 * @param number2 Substrahend
	 * @return sub The result of the substraction
	 */
	public static String subBinary(String number1, String number2){
		int decimal1=0,decimal2=0;
		String sub="";
		boolean carry=false;
		
		//Verifying if the Strings have the same length, if it's not the case add 0's to the left
		//of the shortest String until they have the same length 
		if(number1.length()>number2.length()){
			for(int i=number1.length()-number2.length();i>0;i--){
				number2=0+number2;
			}
		} else if(number1.length()<number2.length()){
			for(int i=number2.length()-number1.length();i>0;i--){
				number1=0+number1;
			}
		}
		
		//We covert from binary to decimal
		for (int i = 0; i < number1.length(); i++) {
			if(number1.charAt(i)=='1') decimal1+=Math.pow(2,(number1.length()-1)-i);
			if(number2.charAt(i)=='1') decimal2+=Math.pow(2,(number1.length()-1)-i);
		}
		
		//We subtract the minuend to the subtrahend
		if(decimal1>decimal2){
			//Compare from right to left the characters of both Strings
			for(int i=number1.length()-1;i>=0;i--){
				//If the carry exist then subtract both characters and 1 in binary
				if (carry){
					sub=(number1.charAt(i)^number2.charAt(i)^1) + sub;
					//If the character of the minued is 1 and the one in the subtrahend is 0
					//then we know that we won't have carry
					if(number1.charAt(i)=='1' & number2.charAt(i)=='0') carry=false;
				} //If there is no carry then subtract both characters in binary
				else sub=(number1.charAt(i)^number2.charAt(i)) + sub;
				//If the characters in the minuend is 1 and the one in the subtrahend is 0 and we
				//don't have carry, then we have carry
				if(number1.charAt(i)=='0' & number2.charAt(i)=='1' & !carry) carry=true;
			}
		} else if (decimal1<decimal2){
			System.out.println("Minuend must be bigger than subtrahend ");
			System.exit(-1);
		} //if they are the same return 0
		else return "0";
				
		return sub;
	}
	
	/**
	 * This method add two binary strings 
	 * @param number1 binary string, number2 binary string
	 * @return add The binary addition of the strings
	 */
	public static String addBinary(String number1, String number2){
		String add="";
		boolean carry=false;
		//Verifying if the Strings have the same length, if it's not the case add 0's to the left
		//of the shortest String until they have the same length 
		if(number1.length()>number2.length()){
			for(int i=number1.length()-number2.length();i>0;i--){
				number2=0+number2;
			}
		} else if(number1.length()<number2.length()){
			for(int i=number2.length()-number1.length();i>0;i--){
				number1=0+number1;
			}
		}
		//Compare from right to left the characters of both Strings
		for(int i=number1.length()-1;i>=0;i--){
			//If the carry exist then add both characters and 1 in binary
			if (carry){
				add=(number1.charAt(i)^number2.charAt(i)^1) + add;
				//If both characters are 0's then we know that we won't have carry
				if(number1.charAt(i)=='0' & number2.charAt(i)=='0') carry=false;
			//If there is no carry then add both characters in binary
			} else add=(number1.charAt(i)^number2.charAt(i)) + add;
			//If both characters are 1's and we don't have carry, then we have carry
			if(number1.charAt(i)=='1' & number2.charAt(i)=='1' & !carry) carry=true;
			//If there is carry in the last bit, add 1 to the result of the addition on the left part
			if(carry & i==0) add='1'+add;
		}
		return add;
	}
	
	/**
	 * This method converts a float number into IEEE 754 format
	 * @see normalize(String, int), floatToBinary(float),integerToBinary(int)
	 * @param realNumber The number that we want to convert
	 * @return sign + " " + exp + " " + createMantissa(normalized) The number in IEEE 754 format
	 */
	public static String floatToIEEE754(float realNumber){
		String sign, exp,normalized="1.";
		int e=0, position=0;
		//Storing the sign
		if (realNumber < 0) sign = "1";
		else sign = "0";
		//Normalizing the mantissa
		String binaryReal=floatToBinary(realNumber);
		//If the first number is different of '1' we look for the position 
		//of the first '1' in the string of characters and we add -1 for each character to the exponent
		if(binaryReal.charAt(0)!='1'){
			//Because we begin in the second position
			e=-1;
			for(int i=2;i<=binaryReal.length()-1;i++){
				if (binaryReal.charAt(i)=='1'){
					position=i;
					break;
				}
				e-=1;
			}
			//Now we add each of the character after the 1 that we found in the previous loop
			for(int i=position;i<=binaryReal.length()-1;i++){
				//If the pointer is in the last character add '0' to the string if the comma
				//is the previous symbol
				if(i==(binaryReal.length()-1)) {
					if(normalized.charAt(normalized.length()-1)=='.')normalized+='0';
				}
				else {
					normalized+=binaryReal.charAt(i+1);
				}
			}
		} //We look for the comma and add 1 to the exponent for every character that it's not 
		else {
			for(int i=1;i<binaryReal.length()-1;i++){
				if(binaryReal.charAt(i)=='.'){
					break;
				}
				e+=1;
			}
			//We form the string normalized
			for(int i=1;i<=binaryReal.length()-1;i++){
				if(binaryReal.charAt(i)!='.') normalized+=binaryReal.charAt(i);
			}
		}
		//We add the bias to the exponent and convert it to binary
		exp=integerToBinary(e+127);
		//Add 0 to the left if there aren't 8 characters
		while(exp.length()!=8) exp= '0'+ exp;
		//If the string has one or more zeros, eliminate them
		while(exp.length()>8 & exp.charAt(0)=='0') exp=exp.substring(1);
		
		// Finally, we calculate the mantissa with the createMantissa method.
		return sign + " " + exp + " " + createMantissa(normalized);
	}
	
	/**
	 * We convert a number into a mantissa with this method
	 * @param normalized Decimal part of a number that we want to convert into a mantissa
	 * @return mantissa The proper mantissa now converted
	 */
	public static String createMantissa(String normalized){
		String mantissa="";
		//With this loop we delete the implicit bit and create the mantissa filling with 0's
		//until reach 23 characters
		for(int i=2;i<=24;i++){
			if(i>=normalized.length())mantissa+='0';
			else mantissa+=normalized.charAt(i);
		}
		return mantissa;
	}
	
	/**
	 * This method coverts a float number into binary
	 * @see integerToBinary(int)
	 * @param number The float to be converted
	 * @return binary The float number converted to binary
	 */
	public static String floatToBinary (float number){
		int real = Math.abs((int) number);
		String binary = integerToBinary(real) + ".";
		float decimal;
		//Getting the decimal part of the float number
		if (number < 0) decimal = Math.abs(number + real);
		else decimal = Math.abs(number - real);
		//Converting the decimal part of the float to binary, multiplying the decimal number
		//by 2 and adding the digit before the point to the string
		for (int i=0;i<24 & decimal !=0;i++){
			decimal = decimal * 2;
			if (decimal >= 1){
				binary += "1";
				//If the number is bigger than 1 we have to subtract 1 and keep doing the process
				decimal = decimal - 1;
			}
			else binary += "0";
		}		
		return binary;
	}
	
	/**
	 * This method converts integer part of the float number    
	 * @param integerNumber The integer number to be converted
	 * @return binary The binary string representing the integer number
	 */
	public static String integerToBinary(int integerNumber){
		if(integerNumber!=0){
			String binary = "";
			int integer = Math.abs(integerNumber);
			//Divide the integer number until 0 and add the remainder to the left part of binary String
			//(Manual technique to transform a integer number to binary)
			while (integer > 0){
				binary = (integer % 2) + binary;
				integer = integer / 2;
			}
			return binary;
		}
		//If the integer number is zero just return the String 0
		return "0";
	}	
}
