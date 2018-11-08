/*
 * Long Truong
 * 015274920
 *
 */
package permutation;

import java.util.Scanner;

/**
 * Permutation
 * @author long truong
 */
public class Permutation {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)
    {
    	Scanner reader = new Scanner(System.in);  // Reading from System.in
    	System.out.println("Enter the word you would like to premutate:");
    	   	
		String alphabet = reader.next();
		int n = alphabet.length();
		int idx = alphabet.indexOf('-');
		
    	if(n == 1)
    		System.out.println("Error! Single alphabet is not accepted");
    	else if (idx != -1)
    		System.out.println("Error!");
    	else {
    		Permutation perm = new Permutation();
            perm.permute(alphabet, 0, n-1);
    	}  
    	  	
    	//once finished
    	reader.close();   
    }
 
    /**
     * permutation function
     * @param str string to calculate permutation for
     * @param m starting index
     * @param p end index
     */
    private void permute(String str, int m, int p)
    {
        if (m == p)
            System.out.println(str);
        else
        {
            for (int k = m; k <= p; k++)
            {
                str = mutate(str,m,k);
                permute(str, m+1, p);
                str = mutate(str,m,k);
            }
        }
    }
 
    /**
     * Swap Characters at position
     * @param b string value
     * @param k position 1
     * @param l position 2
     * @return mutate string
     */
    public String mutate(String b, int k, int l)
    {
        char permp1;
        char[] charArray = b.toCharArray();
        permp1 = charArray[k] ;
        charArray[k] = charArray[l];
        charArray[l] = permp1;
        return String.valueOf(charArray);
    }
}