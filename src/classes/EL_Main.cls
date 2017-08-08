/**
 * Created by Stefan Abramiuk on 08.08.2017.
 */

public with sharing class EL_Main {

    public static List<String> sort(List<String> strings){
        String comparableTypeName = 'EL_Main.StringComparable';
        List<ItemWrapper> items = wrapAndSortList(strings, comparableTypeName);
        List<Object> sortedObjects = extractList(items);
        List<Object> sortedStrings = new List<String>();
        sortedStrings.addAll(sortedObjects);
        return (List<String>) sortedStrings;
    }

    private static List<ItemWrapper> wrapAndSortList(List<Object> objects, String comparableTypeName){
        List<ItemWrapper> itemWrappers = new List<ItemWrapper>();
        for(Object obj : objects){
            Type comparableType = Type.forName(comparableTypeName);
            ItemWrapper item = (ItemWrapper) comparableType.newInstance();
            item.setItem(obj);
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

        Object getItem();
    }

    public class StringComparable implements EL_Main.ItemWrapper, Comparable{
        private String item;

        public void setItem(Object item){
            this.item = (String) item;
        }

        public Object getItem(){
            return item;
        }

        public Integer compareTo(Object compareToObject){
            ItemWrapper itemCompareTo = (ItemWrapper) compareToObject;
            return item.compareTo((String) itemCompareTo.getItem());
        }
    }
}