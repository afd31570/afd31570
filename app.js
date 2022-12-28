function colorSelect(){
​
    let SelecetNumber = document.querySelector("#number").value;
​
    switch (true){
        case SelecetNumber ==1:
            red();
        break;
        case SelecetNumber ==2:
            green();
        break;
        case SelecetNumber ==3:
            blue();
        break;
        
        case SelecetNumber ==4:
            yellow();
        break;
        case SelecetNumber ==5:
            gray();
        break;
        default:
            document.querySelector(".color").innerHTML =`<b> Please Enter Number Between 1-5`;
    }
​
    function red(){
        let red= document.querySelector(".color");
        red.style.background="red";
    }
​
    function green(){
        let green= document.querySelector(".color");
        green.style.background="green";
    }
​
    function blue(){
        let blue= document.querySelector(".color");
        blue.style.background="blue";
    }
​
    function yellow(){
        let yellow= document.querySelector(".color");
        yellow.style.background="yellow";
    }
​
    function gray(){
        let gray= document.querySelector(".color");
        gray.style.background="gray";
    }
}
​
​
function Delete(){
    document.querySelector(".color").innerHTML = " ";
}
