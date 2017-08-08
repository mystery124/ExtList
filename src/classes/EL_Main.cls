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

        List<Object> sortedObjects = getSortedObjects(strings, direction, comparableTypeName);
        List<Object> sortedStrings = new List<String>();
        sortedStrings.addAll(sortedObjects);
        return (List<String>) sortedStrings;
    }

    private static List<Object> getSortedObjects(List<Object> objects, Order direction, String comparableTypeName){
        List<ItemWrapper> items = wrapAndSortList(objects, direction, comparableTypeName);
        List<Object> sortedObjects = extractList(items);
        return sortedObjects;
    }

    private static List<ItemWrapper> wrapAndSortList(List<Object> objects, Order direction, String comparableTypeName){
        List<ItemWrapper> itemWrappers = new List<ItemWrapper>();
        for(Object obj : objects){
            Type comparableType = Type.forName(comparableTypeName);
            ItemWrapper item = (ItemWrapper) comparableType.newInstance();
            item.setItem(obj);
            item.setOrder(direction);
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

    interface ItemWrapper {
        void setItem(Object item);
        void setOrder(Order direction);

        Object getItem();
    }

    public class StringComparable implements EL_Main.ItemWrapper, Comparable{
        private String item;
        private EL_Main.Order direction = EL_Main.Order.ASCENDING;

        public void setItem(Object item){
            this.item = (String) item;
        }

        public void setOrder(Order direction){
            this.direction = direction;
        }

        public Object getItem(){
            return item;
        }

        public Integer compareTo(Object compareToObject){
            ItemWrapper itemCompareTo = (ItemWrapper) compareToObject;
            Integer compareToIndicator = item.compareTo((String) itemCompareTo.getItem());
            return direction == EL_Main.Order.ASCENDING ? compareToIndicator : compareToIndicator * -1;
        }
    }
}