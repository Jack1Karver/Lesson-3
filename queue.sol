
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract queue {
    
    string[] public myQueue = ["John","Mark", "Bill"];

    constructor() public {        
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);        
        tvm.accept();       
    }

modifier checkOwner() {       
     
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        
        _;
    }
    function addHuman(string name) public checkOwner{
        myQueue.push(name);
        
    }
    
    function callHuman() public checkOwner{       
    require(myQueue.length > 0);        
        for(uint i=0; i < myQueue.length-1; i++){
            myQueue[i] = myQueue[i+1];
        }
        myQueue.pop();

    }
}
