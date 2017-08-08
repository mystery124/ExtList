/**
 * Created by Stefan Abramiuk on 08.08.2017.
 */

public with sharing class EL_Main {

    public static List<String> sort(List<String> strings){

        List<ItemWrapper> itemWrappers = new List<ItemWrapper>();
        for(String str : strings){
            ItemWrapper item = new StringComparable();
            item.setItem(str);
            itemWrappers.add(item);
        }
        itemWrappers.sort();

        List<String> sortedStrings = new List<String>();
        for(ItemWrapper item : itemWrappers){
            sortedStrings.add((String)item.getItem());
        }
        return sortedStrings;
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