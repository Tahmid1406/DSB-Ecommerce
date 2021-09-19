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
            result = true;
        }else{
            result = false;
        }
        return result;
    }
}

// Order contract starts here
// Order contract starts here

contract OrderContract is TermContract{
    
    
    address contract_deployer;
    address customer_address = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address seller_address = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    address delivery_man_address = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    
    
    mapping(address => Order) OrderMap;
    mapping(address => int) public Review;
    
    
    
    enum OrderCurrentState {
        Order_Placed,
        Order_Confirmed, 
        Order_Shipped, 
        Product_Delivered,
        Order_Reached,
        Fraudulent_Behavior_Detected, 
        Time_Limit_Exceeded, 
        Product_Not_Satisfactory
        
    }
    OrderCurrentState ordercurrentstatus;
    
    
    
        string msz1 = "Order placed successfully";
        string msz2 = "Fraud detected, order cancelled!";
        string msz7 = "Order confirmed successfully";
        string msz3 = "Order delivered successfully";
        string msz4 = "Out of delivery time, order cancelled";
        string msz5 = "Order shipped successfully";
        string msz6 = "Buyer is not satisfied with product";
        string msz8 = "Delivey man is delivering the order";
        string msz9 = "Order reached to customer";
        
    
        //address buyer_address;
        //address seller_address;
        string product_id;
        uint256 delivery_time;
        int product_price;
        uint256 order_time;
        uint256 response;
    
   struct Order{
        address customer_address;
        address seller_address;
        string product_id;
        uint256 delivery_time;
        int product_price;
        uint order_time;
    }
    Order order;
    
    //struct Review{
      //  address seller_address;
        //int counter;
    //}
    
    uint256 order_placing_time;
    uint256 order_delivery_time;
    string viewCurrentTrace = "Not placed any order";
    string description = "null";
    
    
    modifier onlyContractDeployer(){
        require(msg.sender == contract_deployer);
        _;
    }
    
    modifier onlyCustomer(){
        require(msg.sender == customer_address);
        _;
    }
    
     modifier onlySeller(){
        require(msg.sender == seller_address);
        _;
    }
    
      modifier onlyDeliveryMan(){
        require(msg.sender == delivery_man_address);
        _;
    }
    
    
    constructor() {
        contract_deployer = msg.sender;
    }

    
    event OrderCreation(address seller, address customer, string msz);
    event OrderElimination(address seller, address customer, string msz);
    event OrderDelivery(address seller, address customer, string msz);
    event OrderCancellaition(address seller, address customer, string msz);
    event OrderShipping(address seller, address customer, string msz);
    event OrderConfirmation(address seller, address customer, string msz);
    event ReceiveOrder(address deliveryMan, address customer, string msz);
    event AdjustmentRequestEvent(address seller, string msz);
    event ReputationPointAward(address seller, string msz);
    
    
    
    function setDetails( string memory _product_id, uint256 _delivery_time, int _product_price, int _oldbalanceOrg_, int _newbalanceOrig_,
    int _oldbalanceDest_, int _newbalanceDest_, Type _type_) public onlyContractDeployer { 
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
    
    
    function place_order() public onlyCustomer{
         
         if(TermContract.isFraud(amount, oldbalanceOrg, newbalanceOrig, oldbalanceDest, newbalanceDest, transactionType) == true){
             ordercurrentstatus = OrderCurrentState.Fraudulent_Behavior_Detected;
             viewCurrentTrace = "Fraudulent behavior detected";
             emit OrderElimination(seller_address, customer_address, msz2);
         }
         else{
             OrderMap[customer_address] = Order(customer_address, seller_address, product_id, delivery_time, product_price, block.timestamp);
             ordercurrentstatus = OrderCurrentState.Order_Placed;
             viewCurrentTrace = "Order placed";
             emit OrderCreation(seller_address, customer_address, msz1);
         }
    }
    
    function confirm_order() public onlySeller{
        
        order_placing_time = block.timestamp;
        
        if(ordercurrentstatus == OrderCurrentState.Order_Placed){
             ordercurrentstatus = OrderCurrentState.Order_Confirmed;
             viewCurrentTrace = "Order confirmed";
             emit OrderConfirmation(seller_address, customer_address, msz7);
        }
    }
    

    function initiate_delivery() public onlySeller{
        
        order_delivery_time = block.timestamp;
        
        if(order_delivery_time - order_placing_time <= delivery_time && ordercurrentstatus == OrderCurrentState. Order_Confirmed){
            ordercurrentstatus = OrderCurrentState.Product_Delivered;
            viewCurrentTrace = "Order delivered";
            emit OrderDelivery(seller_address, customer_address, msz3);
        }
        else{
            ordercurrentstatus = OrderCurrentState.Time_Limit_Exceeded;
            viewCurrentTrace = "Order cancelled due to time limit";
            emit OrderCancellaition(seller_address, customer_address, msz4);
        }
    }
    
    function ship_order() public onlyDeliveryMan{
        if(ordercurrentstatus == OrderCurrentState.Product_Delivered){
            viewCurrentTrace = "Order is in shipping stage";
            ordercurrentstatus = OrderCurrentState.Order_Reached;
            emit OrderShipping(seller_address, customer_address, msz8);
        }
    }
    
    
    function receive_order() public onlyCustomer{
        if(ordercurrentstatus == OrderCurrentState.Order_Reached)
        viewCurrentTrace = "Order received by customer";
        emit ReceiveOrder(delivery_man_address, customer_address, msz9);
    }
    
    
    function order_delivery_confirmation() public onlyDeliveryMan{
        if(response == 1 && ordercurrentstatus == OrderCurrentState.Order_Reached){
            ordercurrentstatus = OrderCurrentState.Order_Shipped;
            viewCurrentTrace = "Order shipped";
            positive_review();
            emit OrderShipping(seller_address, customer_address, msz5);
            emit ReputationPointAward(seller_address, "+1 reputation added to the seller address");
        }
        else if (response == 2 && ordercurrentstatus == OrderCurrentState.Order_Reached){
            ordercurrentstatus = OrderCurrentState.Product_Not_Satisfactory;
            viewCurrentTrace = "Unsatisfactory Order delivery";
            negative_review();
            emit OrderShipping(seller_address, customer_address, msz6);
            emit ReputationPointAward(seller_address, "-1 reputation added to the seller address");
        }
        else if (response == 3 && ordercurrentstatus == OrderCurrentState.Order_Reached){
            ordercurrentstatus = OrderCurrentState.Product_Not_Satisfactory;
            viewCurrentTrace = "Very unsatisfactory Order delivery";
            scam_by_advertisement();
            emit OrderShipping(seller_address, customer_address, description);
            emit ReputationPointAward(seller_address, "-3 reputation added to the seller address");
        }
    }
    
    function adjustment_request(string memory msz) public onlySeller{
        emit AdjustmentRequestEvent(seller_address, msz);
    }

    
    function set_response(uint256 _response) public onlyCustomer{
        response = _response;
    }
    
    function set_fraudulent_description(string memory _description) public onlyCustomer{
        description = _description;
    }
    
    function perform_diagnosis(address _seller_address) public onlyContractDeployer {
      Review[_seller_address] -= 1;
    }
    
  
    function track_order() internal view returns (OrderCurrentState) {
        return ordercurrentstatus;
    }
    
    function order_status() public view returns(string memory) {
        return viewCurrentTrace;
    }
    
    function positive_review() internal {
      Review[seller_address] += 1;
    }
    
    function negative_review() internal {
      Review[seller_address] -= 1;
    }
    
    function scam_by_advertisement() internal {
      Review[seller_address] -= 3;
    }
}