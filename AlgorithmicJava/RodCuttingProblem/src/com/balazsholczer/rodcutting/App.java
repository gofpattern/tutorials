package com.balazsholczer.rodcutting;

public class App {

	public static void main(String[] args) {

		int lengthOfRod = 5;
		int[] prices = {2,5,7,3};
		
		RodCutting rodCutting = new RodCutting();
		rodCutting.dynamicProgrammingApproach(lengthOfRod, prices);
		
	}
}
