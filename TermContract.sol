 pragma solidity >=0.7.0 <0.9.0;
 
 
 
 
 
 contract TermContract{
    
    
    //variables as per dataset
    int oldbalanceOrg;
    int newbalanceOrig;
    int oldbalanceDest;
    int newbalanceDest;
    int amount;
    
    enum Type{ 
        TRANSFER, 
        CASH_OUT 
    }
    
    Type transactionType;
    
    
    function isFraud(int _amount, int _oldbalanceOrg, int _newbalanceOrig, int _oldbalanceDest, int _newbalanceDest, Type _type) internal returns (bool){
        
        amount = _amount;
        oldbalanceOrg = _oldbalanceOrg;
        oldbalanceDest = _oldbalanceDest;
        newbalanceOrig = _newbalanceOrig;
        newbalanceDest = _newbalanceDest;
        transactionType = _type;
        
        return checkFraud();
    }
    
    function checkFraud() view internal returns (bool){
        bool result; 
        
        // (type = TRANSFER) and (newbalanceDest <= 0) and (oldbalanceDest <= 0) and (oldbalanceOrg >= 64083.54) 
        // (amount >= 491517.77) and (newbalanceOrig <= 0) and (oldbalanceOrg >= 790332.43) 
        // (type = TRANSFER) and (newbalanceDest <= 0) and (oldbalanceDest <= 0) 
        // (oldbalanceDest <= 667243.49) and (oldbalanceOrg >= 1048388.34) and (amount >= 994453.2) 
        // (type = TRANSFER) and (newbalanceDest <= 0) and (oldbalanceDest <= 0) and (oldbalanceOrg >= 64083.54) and (amount >= 84007.22) 
        // (type = CASH_OUT) and (newbalanceOrig <= 0) and (oldbalanceOrg >= 555574.92)
        
        
        if(transactionType == Type.TRANSFER && oldbalanceOrg <= 0 && oldbalanceDest <= 0 && oldbalanceOrg >= 64084){
            result = true;
        }else if(amount >= 491518 && newbalanceOrig <= 0 && oldbalanceOrg >= 790332 ){
             result = true;
        }else if(transactionType == Type.TRANSFER && newbalanceDest <= 0 && oldbalanceDest <= 0){
            result = true;
        }else if( oldbalanceDest <= 667244 && oldbalanceOrg >= 1048388 && amount >= 994453){
            result = true;
        }else if(transactionType == Type.TRANSFER && newbalanceDest <= 0 && oldbalanceDest <= 0 && oldbalanceOrg >= 64084 && amount >= 84007){
            result = true;
        }else if(transactionType == Type.CASH_OUT && newbalanceOrig <= 0 && oldbalanceOrg >= 555575){ 
            
        }else{
            result = false;
        }
        
    }
    
    
    
}












// Order contract starts here
// Order contract starts here

contract OrderContract is TermContract{
    
    // assuming that 
    // 0 = default
    // 1= order Placed
    // 2 = order confirmed
    // 3 = order shipped
    // 4 = product delivered
    // 5 = time limit exceeded
    
    string viewCurrentTrace = "There is no current order";
    
    
    mapping(address => Order) public OrderMap;
    
    enum OrderCurrentState { Order_Placed, Order_received, Order_confirmed, Order_Shipped, Order_Failed }
    OrderCurrentState ordercurrentstatus;
    
    
    
    enum OrderStatus { msz1, msz2, msz3, msz4 }
    
        string msz1 = "Order Placed successfully";
        string msz2 = "Fraud detected,Order cancelled!";
        string msz3 = "Order delivered successfully";
        string msz4 = "Out of time, Order cancelled";
    
        address buyer_address;
        address seller_address;
        string product_id;
        uint256 delivery_time;
        int product_price;
        OrderStatus status;
        uint256 order_time;
    
   struct Order{
        address buyer_address;
        address seller_address;
        string product_id;
        uint256 delivery_time;
        int product_price;
        uint order_time;
    }
    
    Order order;
    
    uint256 order_placing_time;
    uint256 order_delivery_time;
   

    
    event OrderCreation(address seller, address buyer, OrderStatus order_status);
    event OrderElimination(address seller, address buyer, OrderStatus order_status);
    event OrderDelivered(address seller, address buyer, OrderStatus order_status);
    event OrderCancellaition(address seller, address buyer, OrderStatus order_status);
    
    
    
    function setDetails( address _buyer_address, address _seller_address, string memory _product_id, uint256 _delivery_time, 
    int _product_price, int _oldbalanceOrg_, int _newbalanceOrig_, int _oldbalanceDest_, int _newbalanceDest_, Type _type_) public { 
        buyer_address = _buyer_address;
        seller_address = _seller_address;
        product_id = _product_id;
        delivery_time = _delivery_time;
        product_price = _product_price;
        amount = _product_price;
        oldbalanceOrg = _oldbalanceOrg_;
        oldbalanceDest = _oldbalanceDest_;
        newbalanceOrig = _newbalanceOrig_;
        newbalanceDest = _newbalanceDest_;
        transactionType=_type_;
    }
    
    
    
    function place_order() public {
         order_placing_time = block.timestamp;
         
         if(TermContract.isFraud(amount, oldbalanceOrg, newbalanceOrig, oldbalanceDest, newbalanceDest, transactionType) == true){
             emit OrderElimination(seller_address, buyer_address, OrderStatus.msz2);
         }
         else{
             OrderMap[buyer_address] = Order(buyer_address, seller_address, product_id, delivery_time, product_price, block.timestamp);
             emit OrderCreation(seller_address, buyer_address,OrderStatus.msz2);
             viewCurrentTrace = "Order Placed";
         }
    }
    

    function Order_Delivery() public {
        
        order_delivery_time = block.timestamp;
        
        if(order_delivery_time - order_placing_time <= delivery_time){
            emit OrderDelivered(order.seller_address, order.buyer_address, OrderStatus.msz3);
        }
        else{
            emit OrderCancellaition(order.seller_address, order.buyer_address, OrderStatus.msz4);
        }
        
         

    }
    

    function getCurrentStatus() public view returns(string memory) {
        return viewCurrentTrace;
    }

    
}