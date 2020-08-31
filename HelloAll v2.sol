{\rtf1\ansi\deff0\nouicompat{\fonttbl{\f0\fnil\fcharset0 Calibri;}}
{\*\generator Riched20 10.0.18362}\viewkind4\uc1 
\pard\sa200\sl276\slmult1\f0\fs22\lang9 pragma solidity 0.5.12;\par
pragma experimental ABIEncoderV2;\par
\par
contract HelloWorld1\{\par
    string public message = "Hello World, My First Contract" ;\par
    \par
    //for every public variable a get function is auto-generated but for tut, we will create it tooo\par
    function getMessage() public view returns(string memory)\{\par
        return message;\par
    \}\par
    \par
    //to edit a string\par
    function setMessage(string memory newMessage) public \{\par
        message = newMessage;\par
    \}\par
    \par
\}\par
\par
contract HelloTypes\{\par
    string public msg = "Hello to Types";\par
    //unsigned integer  -> we can have both + and -ve integers\par
    uint public number = 123;\par
    bool public isHappy = true;\par
    address public contractCreator = 0xa92D8Dd48C05CAd527ac9Af5D0c05f02feC95880;\par
    \par
    //Array\par
    uint[] public numbers = [1, 20, 85];\par
    //fixed size array- cant have fn to add number to it as size is fixed\par
    uint[4] public fixarr = [565, 837983, 5435];\par
    \par
    function getNum(uint index) public view returns(uint)\{\par
        return numbers[index];\par
    \}\par
    \par
    function setNum(uint newNumber, uint index) public \{\par
        numbers[index] = newNumber;\par
    \}\par
    \par
    //no index given here as number is added to the end of the array\par
    //returns nothing just adds the number\par
    function addNum(uint newNumber) public \{\par
        numbers.push(newNumber);\par
    \}\par
        \par
\}\par
\par
contract HelloObj\{\par
    struct Person \{\par
        uint id;\par
        string name;\par
        uint age;\par
        uint height;\par
        //address walletAddr;\par
    \}\par
    \par
    //name of the array is people\par
    Person[] public people;\par
    \par
    //create a Person and put it in array named people\par
    //argument names could be different from actual parameter name\par
    function createPerson(string memory name, uint age, uint height) public\{\par
    //first Person will get ID will be 0 and next one 1 and so on\par
    \par
        people.push(Person(people.length, name, age, height));\par
        //alternate way to createPerson by breaking up \par
        //Person memory newPerson;\par
        //newPerson.id = people.length;\par
        //newPerson.name = name;\par
        //newPerson.age = age;\par
        //newPerson.height = height;\par
        //people.push(newPerson);\par
        \par
    \}\par
    \par
\}\par
\par
\par
contract HelloMapping\{\par
    //Mappings Key->Value - effective to look-up like a\par
    //Dictionary\par
    //Advantage over Array- in array of 100 elements, \par
    //you might have to go through 50 iterations using index or \par
    //more depending on location of the search result exist in the array/ trial and error method\par
    //In Mapping, simply have to look for a key hence, search is more efficient and safe\par
    struct Person \{\par
        uint id;\par
        string name;\par
        uint age;\par
        uint height;\par
        bool senior;\par
        bool infant;\par
    \}\par
    \par
    //declaration make owner public for testing\par
    address public owner;\par
    \par
    //called only once at the first call of the contract\par
    constructor() public\{\par
        //set the owmer\par
        owner = msg.sender;\par
    \}\par
        //address walletAddr;\par
        //Message.sender -> gives the eth address \par
        //of the actual caller of the function\par
        \par
        //Comparison with array\par
        //mapping(address => Person) public people;\par
        //If we don't use public then getter function is not auto created and avbl to public\par
        mapping(address => Person) private people;\par
        //As an admin, I need the list of address which created the person otherwise \par
        //I will not be able to find which person was created by which address to allow its deletion later\par
        //We will need an address array for that to iterate and match the address, will keep it private for admin use only\par
        address[] private creators;\par
        \par
        \par
        //Private fn example\par
        function insertPerson(Person memory newPerson) private\{\par
            //won't return anything\par
             //creator is the Key => newPerson is the value\par
        address creator = msg.sender;\par
        people[creator] = newPerson;\par
        \}\par
        \par
    function createPerson(string memory fname, uint fage, uint fhgt ) public\{\par
        require(fage <= 150, "Age needs to be below 150");\par
        //This creates a person\par
        Person memory newPerson;\par
        //mapping does have length\par
        //newPerson.id = people.length;\par
        newPerson.name = fname;\par
        newPerson.age = fage;\par
        newPerson.height = fhgt;\par
        \par
        if(fage >= 65)\{\par
            newPerson.senior = true;\par
        \}\par
        else if(fage < 3)\{\par
            newPerson.infant = true;\par
        \}\par
        else\{\par
            newPerson.senior = false;\par
        \}\par
        //call the private helper function-happens under the hood\par
        insertPerson(newPerson);\par
        creators.push(msg.sender);\par
        //check for invariants, in blockchain we compare hashes using keccak256(abi.encodePacked(<argument1>, <argument2>) as struct cannot be compared using ==\par
        //abi.encodePacked -> convert argument to hexadecimal and keccak256 changes this hexadec string to hash\par
        //equiv to assert(people[msg.sender] == newPerson)\par
        assert(\par
            keccak256(\par
                abi.encodePacked(\par
                    people[msg.sender].name, \par
                    people[msg.sender].age, \par
                    people[msg.sender].height, \par
                    people[msg.sender].senior, \par
                    people[msg.sender].infant)) \par
            == keccak256(\par
                abi.encodePacked(\par
                    newPerson.name,\par
                    newPerson.age,\par
                    newPerson.height,\par
                    newPerson.senior,\par
                    newPerson.infant))); \par
    \}    \par
    \par
    \par
    //getter function to ensure that user can't assign data to random address rather createPerson \par
    //is for specific caller/sender address\par
    //current version does not support returning struct but available in another version\par
    //hence on top we wrote pragma experimental <Version>\par
    //function getPerson() public returns(Person memory)\{\}\par
    //But, to use production ready code, we return individual parameters\par
    //getter function - use view option in function to make it cheaper to run \par
    //We wrapped a private mapping named people inside a public getPerson() function so that people can be accessed though default getter function \par
    //is not executed unlike in the case of public attributes\par
    function getPerson() public view returns(string memory name, uint age, uint height, bool senior, bool infant)\{\par
        //short syntax\par
        //people[msg.sender];\par
        address creator = msg.sender;\par
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior, people[creator].infant);\par
        //experimental encoder syntax\par
        //return (people[creator]);\par
        \par
    //For testing, change the address under Account and person created will be accesible for a unique address key\par
    \}\par
    \par
    function deletePerson(address creator)public\{\par
        require(msg.sender == owner, "Caller needs to be the owner");\par
        delete people[creator];\par
        //to ensure, deletion took place, age should be 0 -> check for invariant\par
        assert(people[creator].age == 0);\par
        //Uncoment below line for testing: "Age didn't change to 10-wierd test to check if assert is working"\par
        //assert(people[creator].age == 10);\par
    \}\par
    \par
    function getCreator(uint index) public view returns(address)\{\par
        require(msg.sender == owner);\par
        return creators[index];\par
    \}\par
\}\par
    \par
\par
//Visibility: External, Internal, Private, Public\par
//External: only other contracts not by same contract\par
//Internal: Private and contracts deriving from it\par
//Private: access/call only within same contract ->(avoid getting confused!!) doesn't mean data is not visible to others, only they can't directly query using this fn/\par
//private/attributes from outside that contract. helper function use\par
//Public: Everyone can access/execute \par
\par
\par
\par
\par
}
 