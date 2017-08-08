/**
 * Created by Stefan Abramiuk on 08.08.2017.
 */

@isTest
private class EL_Main_Test {

    @isTest
    private static void shouldSortStringsASC() {
        //given
        List<String> unsortedStrings =
                new List<String>{'b', 'c', 'a'};

        //when
        List<String> result = EL_Main.sort(unsortedStrings);

        //then
        System.assertEquals('a', result[0]);
        System.assertEquals('b', result[1]);
        System.assertEquals('c', result[2]);
    }

    @isTest
    private static void shouldLeaveStringUnchanged() {
        //given
        List<String> unsortedStrings =
                new List<String>{'a', 'b', 'c'};

        //when
        List<String> result = EL_Main.sort(unsortedStrings);

        //then
        System.assertEquals('a', result[0]);
        System.assertEquals('b', result[1]);
        System.assertEquals('c', result[2]);
    }
}