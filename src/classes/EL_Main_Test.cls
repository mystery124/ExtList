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

    @isTest
    private static void shouldReverseDirectionOfList() {
        //given
        List<String> unsortedStrings =
                new List<String>{'a', 'b', 'c'};

        //when
        List<String> result = EL_Main.sort(unsortedStrings, EL_Main.Order.DESCENDING);

        //then
        System.assertEquals('c', result[0]);
        System.assertEquals('b', result[1]);
        System.assertEquals('a', result[2]);
    }

    @isTest
    private static void shouldLeaveListInReversedDirection() {
        //given
        List<String> unsortedStrings =
                new List<String>{'c', 'b', 'a'};

        //when
        List<String> result = EL_Main.sort(unsortedStrings, EL_Main.Order.DESCENDING);

        //then
        System.assertEquals('c', result[0]);
        System.assertEquals('b', result[1]);
        System.assertEquals('a', result[2]);
    }

    @isTest
    private static void shouldSortDatesASC() {
        //given
        List<Date> unsortedDates =
                new List<Date>{
                        Date.today().addDays(1),
                        Date.today().addDays(2),
                        Date.today()
                };

        //when
        List<Date> result = EL_Main.sort(unsortedDates);

        //then
        System.assertEquals(Date.today(), result[0]);
        System.assertEquals(Date.today().addDays(1), result[1]);
        System.assertEquals(Date.today().addDays(2), result[2]);
    }

    @isTest
    private static void shouldSortDatesDESC() {
        //given
        List<Date> unsortedDates =
                new List<Date>{
                        Date.today().addDays(1),
                        Date.today().addDays(2),
                        Date.today()
                };

        //when
        List<Date> result = EL_Main.sort(unsortedDates, EL_Main.Order.DESCENDING);

        //then
        System.assertEquals(Date.today().addDays(2), result[0]);
        System.assertEquals(Date.today().addDays(1), result[1]);
        System.assertEquals(Date.today(), result[2]);
    }


    @isTest
    private static void shouldSortCustomObjectASCByNameField() {
        //given
        Container a = new Container();
        a.name = 'a';
        Container b = new Container();
        b.name = 'b';
        Container c = new Container();
        c.name = 'c';
        List<Container> unsortedObjects =
                new List<Container>{
                        b, c, a
                };
        List<EL_Main.SortingContext> sortingContext = new List<EL_Main.SortingContext>();
        EL_Main.SortingContext context = new EL_Main.SortingContext('name', EL_Main.Order.ASCENDING);
        sortingContext.add(context);

        //when
        List<Object> result = EL_Main.sort(unsortedObjects, sortingContext);

        //then
        System.assertEquals('a', ((Container) result[0]).name);
        System.assertEquals('b', ((Container) result[1]).name);
        System.assertEquals('c', ((Container) result[2]).name);
    }

    @isTest
    private static void shouldThrowExceptionWhenCustomObjectDontHaveGivenField() {
        //given
        Container a = new Container();
        a.name = 'a';
        Container b = new Container();
        b.name = 'b';
        Container c = new Container();
        c.name = 'c';
        List<Container> unsortedObjects =
                new List<Container>{
                        b, c, a
                };
        List<EL_Main.SortingContext> sortingContext = new List<EL_Main.SortingContext>();
        EL_Main.SortingContext context = new EL_Main.SortingContext('name1', EL_Main.Order.ASCENDING);
        sortingContext.add(context);

        //when
        try {
            List<Object> result = EL_Main.sort(unsortedObjects, sortingContext);

            //then
            System.assert(false, 'Exception was not thrown');
        } catch (Exception ex){
            System.assert(ex instanceof EL_Main.InvalidFieldException, 'Wrong exception detected');
        }
    }

    @isTest
    private static void shouldSortCustomObjectDESCByNameField() {
        //given
        Container a = new Container();
        a.name = 'a';
        Container b = new Container();
        b.name = 'b';
        Container c = new Container();
        c.name = 'c';
        List<Container> unsortedObjects =
                new List<Container>{
                        b, c, a
                };
        List<EL_Main.SortingContext> sortingContext = new List<EL_Main.SortingContext>();
        EL_Main.SortingContext context = new EL_Main.SortingContext('name', EL_Main.Order.DESCENDING);
        sortingContext.add(context);

        //when
        List<Object> result = EL_Main.sort(unsortedObjects, sortingContext);

        //then
        System.assertEquals('c', ((Container) result[0]).name);
        System.assertEquals('b', ((Container) result[1]).name);
        System.assertEquals('a', ((Container) result[2]).name);
    }

    @isTest
    private static void shouldSortCustomObjectASCByNameFieldOfInnerClass() {
        //given
        Container a = new Container();
        a.name = 'a';
        Container innerA = new Container();
        innerA.name = 'a';
        a.cont = innerA;

        Container b = new Container();
        b.name = 'b';
        Container innerB = new Container();
        innerB.name = 'b';
        b.cont = innerB;

        Container c = new Container();
        c.name = 'c';
        Container innerC = new Container();
        innerC.name = 'c';
        c.cont = innerC;

        List<Container> unsortedObjects =
                new List<Container>{
                        b, c, a
                };
        List<EL_Main.SortingContext> sortingContext = new List<EL_Main.SortingContext>();
        EL_Main.SortingContext context = new EL_Main.SortingContext('cont.name', EL_Main.Order.ASCENDING);
        sortingContext.add(context);

        //when
        List<Object> result = EL_Main.sort(unsortedObjects, sortingContext);

        //then
        System.assertEquals('a', ((Container) result[0]).name);
        System.assertEquals('b', ((Container) result[1]).name);
        System.assertEquals('c', ((Container) result[2]).name);
    }

    @isTest
    private static void shouldSortCustomObjectASCByNameFieldOfBaseAndInnerClass() {
        //given
        Container a = new Container();
        a.name = 'a';
        Container innerA = new Container();
        innerA.name = 'a';
        a.cont = innerA;

        Container ab = new Container();
        ab.name = 'a';
        Container innerB = new Container();
        innerB.name = 'b';
        ab.cont = innerB;

        Container c = new Container();
        c.name = 'c';
        Container innerC = new Container();
        innerC.name = 'c';
        c.cont = innerC;

        List<Container> unsortedObjects =
                new List<Container>{
                        ab, c, a
                };
        List<EL_Main.SortingContext> sortingContext = new List<EL_Main.SortingContext>();
        EL_Main.SortingContext contextLevel1 = new EL_Main.SortingContext('name', EL_Main.Order.ASCENDING);
        EL_Main.SortingContext contextLevel2 = new EL_Main.SortingContext('cont.name', EL_Main.Order.ASCENDING);
        sortingContext.add(contextLevel1);
        sortingContext.add(contextLevel2);

        //when
        List<Object> result = EL_Main.sort(unsortedObjects, sortingContext);

        //then
        System.assertEquals('a', ((Container) result[0]).name);
        System.assertEquals('a', ((Container) result[0]).cont.name);
        System.assertEquals('a', ((Container) result[1]).name);
        System.assertEquals('b', ((Container) result[1]).cont.name);
        System.assertEquals('c', ((Container) result[2]).name);
    }

    public class Container implements EL_Main.ExtListItem{
        public String name;
        public Container cont;
    }
}