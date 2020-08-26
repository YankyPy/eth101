pragma solidity 0.5.12;
pragma experimental ABIEncoderV2;

contract HelloWorld1{
    string public message = "Hello World, My First Contract" ;
    
    //for every public variable a get function is auto-generated but for tut, we will create it tooo
    function getMessage() public view returns(string memory){
        return message;
    }
    
    //to edit a string
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
    
}

contract HelloTypes{
    string public msg = "Hello to Types";
    //unsigned integer  -> we can have both + and -ve integers
    uint public number = 123;
    bool public isHappy = true;
    address public contractCreator = 0xa92D8Dd48C05CAd527ac9Af5D0c05f02feC95880;
    
    //Array
    uint[] public numbers = [1, 20, 85];
    //fixed size array- cant have fn to add number to it as size is fixed
    uint[4] public fixarr = [565, 837983, 5435];
    
    function getNum(uint index) public view returns(uint){
        return numbers[index];
    }
    
    function setNum(uint newNumber, uint index) public {
        numbers[index] = newNumber;
    }
    
    //no index given here as number is added to the end of the array
    //returns nothing just adds the number
    function addNum(uint newNumber) public {
        numbers.push(newNumber);
    }
        
}

contract HelloObj{
    struct Person {
        uint id;
        string name;
        uint age;
        uint height;
        //address walletAddr;
    }
    
    //name of the array is people
    Person[] public people;
    
    //create a Person and put it in array named people
    //argument names could be different from actual parameter name
    function createPerson(string memory name, uint age, uint height) public{
    //first Person will get ID will be 0 and next one 1 and so on
    
        people.push(Person(people.length, name, age, height));
        //alternate way to createPerson by breaking up 
        //Person memory newPerson;
        //newPerson.id = people.length;
        //newPerson.name = name;
        //newPerson.age = age;
        //newPerson.height = height;
        //people.push(newPerson);
        
    }
    
}


contract HelloMapping{
    //Mappings Key->Value - effective to look-up like a
    //Dictionary
    //Advantage over Array- in array of 100 elements, 
    //you might have to go through 50 iterations using index or 
    //more depending on location of the search result exist in the array/ trial and error method
    //In Mapping, simply have to look for a key hence, search is more efficient and safe
    struct Person {
        uint id;
        string name;
        uint age;
        uint height;
        bool senior;
        bool infant;
    }
    
    //declaration make owner public for testing
    address public owner;
    
    //called only once at the first call of the contract
    constructor() public{
        //set the owmer
        owner = msg.sender;
    }
        //address walletAddr;
        //Message.sender -> gives the eth address 
        //of the actual caller of the function
        
        //Comparison with array
        //mapping(address => Person) public people;
        //If we don't use public then getter function is not auto created and avbl to public
        mapping(address => Person) private people;
        //As an admin, I need the list of address which created the person otherwise 
        //I will not be able to find which person was created by which address to allow its deletion later
        //We will need an address array for that to iterate and match the address, will keep it private for admin use only
        address[] private creators;
        
        
        //Private fn example
        function insertPerson(Person memory newPerson) private{
            //won't return anything
             //creator is the Key => newPerson is the value
        address creator = msg.sender;
        people[creator] = newPerson;
        }
        
    function createPerson(string memory fname, uint fage, uint fhgt ) public{
        require(fage <= 150, "Age needs to be below 150");
        //This creates a person
        Person memory newPerson;
        //mapping does have length
        //newPerson.id = people.length;
        newPerson.name = fname;
        newPerson.age = fage;
        newPerson.height = fhgt;
        
        if(fage >= 65){
            newPerson.senior = true;
        }
        else if(fage < 3){
            newPerson.infant = true;
        }
        else{
            newPerson.senior = false;
        }
        //call the private helper function-happens under the hood
        insertPerson(newPerson);
        creators.push(msg.sender);
        //check for invariants, in blockchain we compare hashes using keccak256(abi.encodePacked(<argument1>, <argument2>) as struct cannot be compared using ==
        //abi.encodePacked -> convert argument to hexadecimal and keccak256 changes this hexadec string to hash
        //equiv to assert(people[msg.sender] == newPerson)
        assert(
            keccak256(
                abi.encodePacked(
                    people[msg.sender].name, 
                    people[msg.sender].age, 
                    people[msg.sender].height, 
                    people[msg.sender].senior, 
                    people[msg.sender].infant)) 
            == keccak256(
                abi.encodePacked(
                    newPerson.name,
                    newPerson.age,
                    newPerson.height,
                    newPerson.senior,
                    newPerson.infant))); 
    }    
    
    
    //getter function to ensure that user can't assign data to random address rather createPerson 
    //is for specific caller/sender address
    //current version does not support returning struct but available in another version
    //hence on top we wrote pragma experimental <Version>
    //function getPerson() public returns(Person memory){}
    //But, to use production ready code, we return individual parameters
    //getter function - use view option in function to make it cheaper to run 
    //We wrapped a private mapping named people inside a public getPerson() function so that people can be accessed though default getter function 
    //is not executed unlike in the case of public attributes
    function getPerson() public view returns(string memory name, uint age, uint height, bool senior, bool infant){
        //short syntax
        //people[msg.sender];
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior, people[creator].infant);
        //experimental encoder syntax
        //return (people[creator]);
        
    //For testing, change the address under Account and person created will be accesible for a unique address key
    }
    
    function deletePerson(address creator)public{
        require(msg.sender == owner, "Caller needs to be the owner");
        delete people[creator];
        //to ensure, deletion took place, age should be 0 -> check for invariant
        assert(people[creator].age == 0);
        //Uncoment below line for testing: "Age didn't change to 10-wierd test to check if assert is working"
        //assert(people[creator].age == 10);
    }
    
    function getCreator(uint index) public view returns(address){
        require(msg.sender == owner);
        return creators[index];
    }
}
    

//Visibility: External, Internal, Private, Public
//External: only other contracts not by same contract
//Internal: Private and contracts deriving from it
//Private: access/call only within same contract ->(avoid getting confused!!) doesn't mean data is not visible to others, only they can't directly query using this fn/
//private/attributes from outside that contract. helper function use
//Public: Everyone can access/execute 




