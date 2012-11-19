package firstPractice;

/**
 * Exercise2 class
 * @version 1
 * @author Adrian Mª Mora Carreto NIA: 100291775
 * @author Ramses Joel Salas Machado NIA:100292149
 */

public class IntegerNumber{
	
	//Testing the methods
	public static void main(String [] args){
		System.out.println(intToComp2(32));
	}

	/**
	 *This method converts an integer number in it's 2's complemente representation  
	 * @see intToComp1(integer)
	 * @param integerNumber Integer number to be converted to 2's complement
	 * @return comp2 The integer number converted in 2's complement
	 */
	public static String intToComp2(int integerNumber){
		String comp2=intToComp1(integerNumber);
		//If the integer is negative add 1 in binary to the 1's complement
		//else return the 1's complement 
		if(integerNumber<0) return addBinary(comp2,"1");
		return comp2;
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
	 * This method converts a given integer number to it's 1's complement representation 
	 * @see integerToBinary(int)
	 * @param integerNumber the integer number to be converted
	 * @return comp1 The integer number converted in 1's complement
	 */
	public static String intToComp1(int integerNumber){
		String binary=integerToBinary(integerNumber);
		//If the integer is negative swap 0's for 1's and vice versa
		if (integerNumber<0){
			String comp1="1";
			for(int i=0; i<binary.length();i++){
				if(binary.charAt(i)=='0') comp1+="1";
				else if (binary.charAt(i)=='1') comp1+="0";
			}
			return comp1;
			//If the integer is positive add a zero to the left part of the binary String
		} else if (integerNumber>0){
			String comp1="0" + binary;
			return comp1;
		}
		return "0";
	}
	
	/**
	 * This method converts integers to binary numbers   
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

