/**
 * Created by Stefan Abramiuk on 09.08.2017.
 */

public class EL_PrimitiveComparator {

    private static Integer compareNulls(Object a, Object b){
        if(a == null && b == null){
            return 0;
        } else if(a == null){
            return 1;
        } else {
            return -1;
        }
    }

    public static Integer compareAtoB(String a, String b){
        if(a == null || b == null){
            return compareNulls(a, b);
        } else {
            return a.compareTo(b);
        }
    }

    public static Integer compareAtoB(Date a, Date b){
        if(a == null || b == null){
            return compareNulls(a, b);
        } else {
            return a > b ? 1 : (a < b ? -1 : 0);
        }
    }

    public static Integer compareAtoB(Datetime a, Datetime b){
        if(a == null || b == null){
            return compareNulls(a, b);
        } else {
            return a > b ? 1 : (a < b ? -1 : 0);
        }    }

    public static Integer compareAtoB(Time a, Time b){
        if(a == null || b == null){
            return compareNulls(a, b);
        } else {
            return a > b ? 1 : (a < b ? -1 : 0);
        }    }

    public static Integer compareAtoB(Integer a, Integer b){
        if(a == null || b == null){
            return compareNulls(a, b);
        } else {
            return a > b ? 1 : (a < b ? -1 : 0);
        }    }

    public static Integer compareAtoB(Decimal a, Decimal b){
        if(a == null || b == null){
            return compareNulls(a, b);
        } else {
            return a > b ? 1 : (a < b ? -1 : 0);
        }    }

    public static Integer compareAtoB(Double a, Double b){
        if(a == null || b == null){
            return compareNulls(a, b);
        } else {
            return a > b ? 1 : (a < b ? -1 : 0);
        }    }

    public static Integer compareAtoB(Long a, Long b){
        if(a == null || b == null){
            return compareNulls(a, b);
        } else {
            return a > b ? 1 : (a < b ? -1 : 0);
        }    }

    public static Integer compareAtoB(Boolean a, Boolean b){
        if(a == null || b == null){
            return compareNulls(a, b);
        } else {
            return a == b ? 0 : (a == true ? 1 : -1);
        }
    }

    public static Integer compareAtoB(Object a, Object b){
        if(a instanceof String){
            return compareAtoB((String)a, (String) b);
        } else if(a instanceof Integer){
            return compareAtoB((Integer)a, (Integer) b);
        } else if(a instanceof Long){
            return compareAtoB((Long)a, (Long) b);
        } else if(a instanceof Double){
            return compareAtoB((Double)a, (Double) b);
        } else if(a instanceof Decimal){
            return compareAtoB((Decimal)a, (Decimal) b);
        } else if(a instanceof Date){
            return compareAtoB((Date)a, (Date) b);
        } else if(a instanceof Datetime){
            return compareAtoB((Datetime)a, (Datetime) b);
        } else if(a instanceof Time){
            return compareAtoB((Time)a, (Time) b);
        } else if(a instanceof Boolean){
            return compareAtoB((Boolean)a, (Boolean) b);
        }
        return 0;
    }
}