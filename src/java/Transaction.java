
public class Transaction {
    public int from, to , id;
    public double amount ;
    boolean removable ;
    
    public Transaction(){}
    
    public Transaction(int id, int from, int to, double amount, boolean isRemovable){
        this.id = id ;
        this.from = from ;
        this.to = to ;
        this.amount = amount ;
        removable = isRemovable; 
    }
}
