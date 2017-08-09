/**
 * Created by Stefan Abramiuk on 08.08.2017.
 */

public with sharing class EL_Main {

    public enum Order {ASCENDING, DESCENDING}

    public static List<String> sort(List<String> strings){
        return sort(strings, Order.ASCENDING);
    }

    public static List<String> sort(List<String> strings, Order direction){
        String comparableTypeName = 'EL_Main.StringComparable';
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
        String comparableTypeName = 'EL_Main.DateComparable';
        ListContext context = new ListContext(dates, direction);
        List<Object> sortedObjects = getSortedObjects(context, comparableTypeName);
        List<Object> sortedDates = new List<Date>();
        sortedDates.addAll(sortedObjects);
        return (List<Date>) sortedDates;
    }

    public static List<Object> sort(List<ExtListItem> items, List<SortingContext> context){
        String comparableTypeName = 'EL_Main.CustomComparable';
        ListContext lContext = new ListContext(items, context);
        List<Object> sortedItems = getSortedObjects(lContext, comparableTypeName);
        return sortedItems;
    }


    private static List<Object> getSortedObjects(ListContext context, String comparableTypeName){
        List<ItemWrapper> items = getWrappedAndSortedList(context, comparableTypeName);
        List<Object> sortedObjects = extractList(items);
        return sortedObjects;
    }

    private static List<ItemWrapper> getWrappedAndSortedList(ListContext context, String comparableTypeName){
        List<ItemWrapper> itemWrappers = new List<ItemWrapper>();
        for(Object obj : context.objects){
            Type comparableType = Type.forName(comparableTypeName);
            ItemWrapper item = (ItemWrapper) comparableType.newInstance();
            item.setItem(obj);
            item.setSortingContext(context.sortingContexts);
            itemWrappers.add(item);
        }
        itemWrappers.sort();
        return itemWrappers;
    }

    private static List<Object> extractList(List<ItemWrapper> itemWrappers){
        List<Object> sortedValues = new List<Object>();
        for(ItemWrapper item : itemWrappers){
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

    public abstract class ItemWrapper {
        public abstract void setItem(Object item);
        public abstract void setSortingContext(List<SortingContext> context);

        public abstract Object getItem();

        protected Integer addDirectionToIndicator(Order direction, Integer indicator){
            return direction == EL_Main.Order.ASCENDING ? indicator : indicator * -1;
        }
    }

    public class StringComparable extends EL_Main.ItemWrapper implements Comparable{
        private String item;
        private EL_Main.Order direction = EL_Main.Order.ASCENDING;

        public override void setItem(Object item){
            this.item = (String) item;
        }

        public override void setSortingContext(List<SortingContext> context){
            this.direction = context[0].direction;
        }

        public override Object getItem(){
            return item;
        }

        public Integer compareTo(Object compareToObject){
            ItemWrapper itemWrapperCompareTo = (ItemWrapper) compareToObject;
            String itemCompareTo = (String) itemWrapperCompareTo.getItem();
            Integer compareToIndicator = EL_PrimitiveComparator.compareAtoB(item, itemCompareTo);
            return addDirectionToIndicator(direction, compareToIndicator);
        }
    }

    public class DateComparable extends EL_Main.ItemWrapper implements Comparable{
        private Date item;
        private EL_Main.Order direction = EL_Main.Order.ASCENDING;

        public override void setItem(Object item){
            this.item = (Date) item;
        }

        public override void setSortingContext(List<SortingContext> context){
            this.direction = context[0].direction;
        }

        public override Object getItem(){
            return item;
        }

        public Integer compareTo(Object compareToObject){
            ItemWrapper itemWrapperCompareTo = (ItemWrapper) compareToObject;
            Date itemCompareTo = (Date) itemWrapperCompareTo.getItem();
            Integer compareToIndicator = EL_PrimitiveComparator.compareAtoB(item, itemCompareTo);
            return addDirectionToIndicator(direction, compareToIndicator);
        }
    }

    public class CustomComparable extends EL_Main.ItemWrapper implements Comparable{
        private Map<String, Object> parsedItem;
        private Object originalItem;
        private List<EL_Main.SortingContext> sortingContext;

        public override void setItem(Object item){
            parsedItem = (Map<String, Object>) Json.deserializeUntyped(JSON.serialize(item));
            originalItem = item;
        }

        public override void setSortingContext(List<SortingContext> context){
            this.sortingContext = context;
        }

        public override Object getItem(){
            return originalItem;
        }

        public Map<String, Object> getParsedItem(){
            return parsedItem;
        }

        public Integer compareTo(Object compareToObject){
            CustomComparable itemWrapperCompareTo = (CustomComparable) compareToObject;
            Map<String, Object> itemCompareTo = (Map<String, Object>) itemWrapperCompareTo.getParsedItem();
            EL_Main.Order direction = EL_Main.Order.ASCENDING;
            Integer compareToIndicator = 0;
            Iterator<SortingContext> contextIterator = sortingContext.iterator();
            while(compareToIndicator == 0 && contextIterator.hasNext()){
                EL_Main.SortingContext context = (EL_Main.SortingContext) contextIterator.next();
                Object valueA = getFieldValueIfFieldExists(parsedItem, context.field);
                Object valueB = getFieldValueIfFieldExists(itemCompareTo, context.field);
                compareToIndicator = EL_PrimitiveComparator.compareAtoB(valueA, valueB);
                direction = context.direction;
            }

            return addDirectionToIndicator(direction, compareToIndicator);
        }

        private Object getFieldValueIfFieldExists(Map<String, Object> record, String fieldPath){
            String[] fields = fieldPath.split('\\.');
            Iterator<String> fieldIterator = fields.iterator();
            Object value = record;
            while(fieldIterator.hasNext()){
                String field = fieldIterator.next();
                Map<String, Object> innerObject = (Map<String, Object>) value;
                if(innerObject.containsKey(field)){
                    value = innerObject.get(field);
                } else {
                    throwErrorIfFieldDontExist(field);
                }
            }
            return value;
        }

        private void throwErrorIfFieldDontExist(String fieldName){
            EL_Main.InvalidFieldException ex = new InvalidFieldException();
            ex.setMessage('Field not found in object: '+fieldName);
            throw ex;
        }
    }

    public interface ExtListItem{}

    public class InvalidFieldException extends Exception {}

}