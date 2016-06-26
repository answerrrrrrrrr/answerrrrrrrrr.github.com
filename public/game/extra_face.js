var numberOfFaces = 5;

function generateFaces() {
    var count = numberOfFaces;
    var theLeftSide = document.getElementById('leftSide');
    console.log(theLeftSide);
    var lSubDiv = document.createElement('div');

    while(count > 0){
        var img = document.createElement('img');
        img.src = 'smile.png'
        img.style.top = randomPx();
        img.style.left = randomPx();

        lSubDiv.appendChild(img);
        theLeftSide.appendChild(lSubDiv);
        count--;
    }

    var theRightSide = document.getElementById('rightSide');
    rSubDiv = lSubDiv.cloneNode(true);
    rSubDiv.removeChild(rSubDiv.lastChild);
    theRightSide.appendChild(rSubDiv);

    lSubDiv.lastChild.onclick =
    function nextLevel(event){
        event.stopPropagation();

        // remove old images
        theLeftSide.removeChild(lSubDiv);
        theRightSide.removeChild(rSubDiv);

        // generate new images
        numberOfFaces += 5;
        generateFaces();
    };

    theBody.onclick = function gameOver() {
    alert("Game Over!");
    theBody.onclick = null;
    theLeftSide.lastChild.onclick = null;
    };

}

function randomPx() {
    return Math.floor(Math.random() * 400) + 'px'
}