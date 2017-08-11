/**
 * Created by Stefan Abramiuk on 10.08.2017.
 */

public with sharing class EL_ComparableContainer {

    public abstract class ItemWrapper implements Comparable {
        public abstract void setItem(Object item);
        public abstract void setSortingContext(List<EL_Main.SortingContext> context);

        public abstract Object getItem();

        protected Integer addDirectionToIndicator(EL_Main.Order direction, Integer indicator){
            return direction == EL_Main.Order.ASCENDING ? indicator : indicator * -1;
        }
    }

    public class StringComparable extends ItemWrapper {
        private String item;
        private EL_Main.Order direction = EL_Main.Order.ASCENDING;

        public override void setItem(Object item){
            this.item = (String) item;
        }

        public override void setSortingContext(List<EL_Main.SortingContext> context){
            direction = context[0].direction;
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

    public class DateComparable extends ItemWrapper {
        private Date item;
        private EL_Main.Order direction = EL_Main.Order.ASCENDING;

        public override void setItem(Object item){
            this.item = (Date) item;
        }

        public override void setSortingContext(List<EL_Main.SortingContext> context){
            direction = context[0].direction;
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

    public class IntegerComparable extends ItemWrapper{
        private Integer item;
        private EL_Main.Order direction = EL_Main.Order.ASCENDING;

        public override void setItem(Object item){
            this.item = Integer.valueOf(item);
        }

        public override void setSortingContext(List<EL_Main.SortingContext> context){
            this.direction = context[0].direction;
        }

        public override Object getItem(){
            return item;
        }

        public Integer compareTo(Object compareToObject){
            ItemWrapper itemWrapperCompareTo = (ItemWrapper) compareToObject;
            Integer itemCompareTo = (Integer) itemWrapperCompareTo.getItem();
            Integer compareToIndicator = EL_PrimitiveComparator.compareAtoB(item, itemCompareTo);
            return addDirectionToIndicator(direction, compareToIndicator);
        }
    }


    public class CustomComparable extends ItemWrapper{
        private Map<String, Object> parsedItem;
        private Object originalItem;
        private List<EL_Main.SortingContext> sortingContext;

        public override void setItem(Object item){
            parsedItem = (Map<String, Object>) Json.deserializeUntyped(JSON.serialize(item));
            originalItem = item;
        }

        public override void setSortingContext(List<EL_Main.SortingContext> context){
            sortingContext = context;
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
            return compareObjectsReturnIndicator(itemCompareTo);
        }

        private Integer compareObjectsReturnIndicator(Map<String, Object> itemCompareTo){
            EL_Main.Order direction = EL_Main.Order.ASCENDING;
            Integer compareToIndicator = 0;
            Iterator<EL_Main.SortingContext> contextIterator = sortingContext.iterator();
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
            EL_Main.InvalidFieldException ex = new EL_Main.InvalidFieldException();
            ex.setMessage('Field not found in object: '+fieldName);
            throw ex;
        }
    }
}