package firstPractice;

/**
 * Exercise3 class
 * @version 1
 * @author Adrian Mª Mora Carreto NIA: 100291775
 * @author Ramses Joel Salas Machado NIA:100292149
 */
 
import java.util.Scanner;

public class RealNumber {
	
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		System.out.println("Introduce the decimal number to convert:");
		try {
			float number = sc.nextFloat();
			System.out.println("The number introduced in IEEE 754 is:");
			System.out.print(floatToIEEE754(number));
		} catch (Exception e){
			System.out.println("NaN");
			System.exit(-1);
		}
	}
	
	/**
	 * This method converts a float number to IEEE754 representation
	 * @see floatToBinary(float), integerToBinary(int)
	 * @param realNumber the float number to be converted
	 * @return sign + " " + exp + " " + mantissa Float number converted to IEEE754
	 */
	public static String floatToIEEE754(float realNumber){
		String sign, exp, mantissa="", normalized="1.";
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
		
		//With this loop we delete the implicit bit and create the mantissa filling with 0's
		//until reach 23 characters
		for(int i=2;i<=24;i++){
			if(i>=normalized.length())mantissa+='0';
			else mantissa+=normalized.charAt(i);
		}
		return sign + " " + exp + " " + mantissa;
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
