pragma solidity ^0.6.1;

contract Ballot {
    
    //Variable 
    uint num;
    address chairperson;
    uint[] finals;
    uint res;
    Participant oui;
    Participant[] participants;
    mapping(address => Voter) voters;
	event Voted(address votant, bool didVote, uint heure);

    //struct
    
    struct Voter {
        bool registered;
        bool voted;
        uint[] vote;
    }
    
    struct Participant {
        uint[]resultat;
    }
    
    //Constructor
    constructor(uint _numProposals) public {
        chairperson = msg.sender;
        num = _numProposals;
        voters[chairperson].registered=true;
        for (uint i=1;i<=num;i++)
            {
                oui.resultat=[0];
                participants.push(oui);
                finals.push(0);
            }
    }
    
    //Modifier
    modifier onlyBy (address req) {
        require(msg.sender==req);
        _;
    }
    modifier canVote (address voter) {
        require(!voters[voter].voted&&voters[voter].registered);
        _;
    }
    
    //Internal function

    function sort(uint[] memory data )internal returns(uint[] memory) {
       quickSort(data, int(0), int(data.length - 1));
       return data;
    }
    
    function max(uint[] memory data)pure private returns(uint){
        uint inter=data[0];
        for (uint i=0;i<data.length;i++){
            if (data[i]>inter) {
                inter=data[i];
            }
        }
        return inter;
    }
    
    
    function quickSort(uint[] memory arr, int left, int right) internal{
        int i = left;
        int j = right;
        if(i==j) return;
        uint pivot = arr[uint(left + (right - left) / 2)];
        while (i <= j) {
            while (arr[uint(i)] < pivot) i++;
            while (pivot < arr[uint(j)]) j--;
            if (i <= j) {
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }


    //Main function
    function register (address aVoter) onlyBy(chairperson) public {
        voters[aVoter].registered=true;
    }
    
    function Vote(uint[] memory listeVote) canVote(msg.sender) public{
        voters[msg.sender].vote=listeVote;
        voters[msg.sender].voted=true;
        for (uint i=0;i<num;i++){
            participants[i].resultat.push(listeVote[i]);
        }
		emit Voted(msg.sender,true,now())
    }
    
    function resultat() onlyBy(chairperson) public returns(uint){
        for (uint i=0;i<num;i++){
            participants[i].resultat=sort(participants[i].resultat);
            uint median=uint((participants[i].resultat.length)/2);
            finals[i]=participants[i].resultat[median];
        }
        res=max(finals);
        return(res);

    }
}
