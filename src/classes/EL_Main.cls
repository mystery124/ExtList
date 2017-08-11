/**
 * Created by Stefan Abramiuk on 08.08.2017.
 */

public with sharing class EL_Main {

    public enum Order {ASCENDING, DESCENDING}

    public static final Map<String, String> COMPARABLE_TYPE_BY_OBJ_TYPE = new Map<String, String>{
            'String' => 'EL_ComparableContainer.StringComparable',
            'string' => 'EL_ComparableContainer.StringComparable',
            'STRING' => 'EL_ComparableContainer.StringComparable',
            'Date'   => 'EL_ComparableContainer.DateComparable',
            'date'   => 'EL_ComparableContainer.DateComparable',
            'DATE'   => 'EL_ComparableContainer.DateComparable'
    };

    public static List<String> sort(List<String> strings){
        return sort(strings, Order.ASCENDING);
    }

    public static ListHolder buildListHolder(List<Object> objects, List<SortingContext> context, String objectType){
        return new ListHolder(objects, context, objectType);
    }

    public static List<String> sort(List<String> strings, Order direction){
        String comparableTypeName = COMPARABLE_TYPE_BY_OBJ_TYPE.get('String');
        ListContext context = new ListContext(strings, direction);
        List<Object> sortedObjects = getSortedObjects(context, comparableTypeName);
        List<Object> sortedStrings = new List<String>();
        sortedStrings.addAll(sortedObjects);
        return (List<String>) sortedStrings;
    }


    public static List<Date> sort(List<Date> dates){
        return sort(dates, Order.ASCENDING);
    }

    public static List<Date> sort(List<Date> dates, Order direction){
        String comparableTypeName = COMPARABLE_TYPE_BY_OBJ_TYPE.get('Date');
        ListContext context = new ListContext(dates, direction);
        List<Object> sortedObjects = getSortedObjects(context, comparableTypeName);
        List<Object> sortedDates = new List<Date>();
        sortedDates.addAll(sortedObjects);
        return (List<Date>) sortedDates;
    }

    public static List<Object> sort(List<ExtListItem> items, List<SortingContext> context){
        String comparableTypeName = 'EL_ComparableContainer.CustomComparable';
        ListContext lContext = new ListContext(items, context);
        List<Object> sortedItems = getSortedObjects(lContext, comparableTypeName);
        return sortedItems;
    }


    private static List<Object> getSortedObjects(ListContext context, String comparableTypeName){
        List<EL_ComparableContainer.ItemWrapper> items = getWrappeddList(context, comparableTypeName);
        List<EL_ComparableContainer.ItemWrapper> sortedItems = sortList(items);
        List<Object> sortedObjects = extractList(items);
        return sortedObjects;
    }

    private static List<EL_ComparableContainer.ItemWrapper> getWrappeddList(ListContext context, String comparableTypeName){
        List<EL_ComparableContainer.ItemWrapper> itemWrappers = new List<EL_ComparableContainer.ItemWrapper>();
        for(Object obj : context.objects){
            Type comparableType = Type.forName(comparableTypeName);
            EL_ComparableContainer.ItemWrapper item = (EL_ComparableContainer.ItemWrapper) comparableType.newInstance();
            item.setItem(obj);
            item.setSortingContext(context.sortingContexts);
            itemWrappers.add(item);
        }
        return itemWrappers;
    }

    private static List<EL_ComparableContainer.ItemWrapper> sortList(List<EL_ComparableContainer.ItemWrapper> itemWrappers){
        itemWrappers.sort();
        return itemWrappers;
    }

    private static List<Object> extractList(List<EL_ComparableContainer.ItemWrapper> itemWrappers){
        List<Object> sortedValues = new List<Object>();
        for(EL_ComparableContainer.ItemWrapper item : itemWrappers){
            sortedValues.add(item.getItem());
        }
        return sortedValues;
    }

    public class ListContext{
        public List<Object> objects;
        public List<SortingContext> sortingContexts;

        public ListContext(List<Object> records, EL_Main.Order direction){
            objects = records;
            sortingContexts = new List<EL_Main.SortingContext>();
            sortingContexts.add(new SortingContext(direction));
        }

        public ListContext(List<Object> records, List<SortingContext> context){
            objects = records;
            sortingContexts = context;
        }
    }

    public class SortingContext{
        public EL_Main.Order direction;
        public String field;
        public Boolean nullsFirst;

        public SortingContext(EL_Main.Order sortDireciton){
            direction = sortDireciton;
        }

        public SortingContext(String fieldName, EL_Main.Order sortDireciton){
            direction = sortDireciton;
            field = fieldName;
        }
    }

    public class ListHolder {
        private String typeOfHoldObject;
        private EL_Main.ListContext context;
        private List<EL_ComparableContainer.ItemWrapper> itemWrappers;

        public ListHolder(List<Object> objects, List<EL_Main.SortingContext> sortingContext, String objectType){
            typeOfHoldObject = objectType;
            String comparableTypeName = 'EL_ComparableContainer.CustomComparable';
            if(COMPARABLE_TYPE_BY_OBJ_TYPE.containsKey(objectType)){
                comparableTypeName = COMPARABLE_TYPE_BY_OBJ_TYPE.get(objectType);
            }
            context = new EL_Main.ListContext(objects, sortingContext);
            itemWrappers = EL_Main.getWrappeddList(context, comparableTypeName);
        }

        public void setSortingContext(List<EL_Main.SortingContext> context){
            for(EL_ComparableContainer.ItemWrapper itemWrapper : itemWrappers){
                itemWrapper.setSortingContext(context);
            }
        }

        public List<Object> sort(){
            itemWrappers.sort();
            List<Object> objects = extractList(itemWrappers);
            String returnType = 'List<'+typeOfHoldObject+'>';
            List<Object> castedObjects = (List<Object>) Type.forName(returnType).newInstance();
            castedObjects.addAll(objects);
            return castedObjects;
        }
    }

    public interface ExtListItem{}

    public class InvalidFieldException extends Exception {}

}