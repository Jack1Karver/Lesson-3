

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract taskList {
    
    struct task  {
        string name;
        uint time;
        bool done;    
    }
    mapping (int8 => task) public map;     
    int8 id = 0;

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

    function addTask(string _name) public checkOwner{       
        id++; 
        map[id] = task(_name,now,false);
                 
    }

    function getOpenTask() public checkOwner returns (uint){
        uint count = 0;
       for(int8 i=1;i<=id;i++){
           if((map[i].done == false)&&(map[i].name != "@deleted@")){
               count++;
            }        
       }
       return count;
    }
    
    function countTasks() private checkOwner returns (uint){
        uint count = 0;
       for(int8 i=1;i<=id;i++){
           if(map[i].name != "@deleted@"){
               count++;
            }        
       }
       return count;

    }

    function returnTasks() public checkOwner returns (task[]){        
        uint taskSize = countTasks();
        task[] t = new task[](taskSize);
        for( int8 i = 1;i<=id;i++){
            if(map[i].name != "@deleted@"){
            t[uint(i-1)] = map[i];
            }            
        }    
        return t;    
    }

    function returnTask(int8 _id) public checkOwner returns(task){
        return map[_id];
    }

    function deleteTask(int8 _id) public checkOwner{
       delete map[_id];
       map[_id].name ="@deleted@";
    }

    function performTask(int8 _id) public checkOwner{
        if (map[_id].name !="@deleted@")
        map[_id].done = true;
    }
}
