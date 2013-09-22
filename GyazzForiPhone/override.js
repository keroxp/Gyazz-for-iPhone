/*
function longmousedown(){
    editline = eline;
    calcdoi();
    display(true);
}

$(document).mousedown(function(event){
    if(reloadTimeout) clearTimeout(reloadTimeout);
    reloadTimeout = setTimeout(reload,reloadInterval);
    y = event.pageY;
    if(y < 40){
        searchmode = true;
        return true;
    }
    searchmode = false;

    if(eline == -1){
        editline = eline;
        calcdoi();
        display(true);
    }else {
        if(editTimeout) clearTimeout(editTimeout);
            editTimeout = setTimeout(longmousedown,300);
        }
    }
);
*/

$(document).mousedown(function(event){
    event.preventDefault();
    if(reloadTimeout) clearTimeout(reloadTimeout);
    reloadTimeout = setTimeout(reload,reloadInterval);
    y = event.pageY;
    if(y < 40){
        searchmode = true;
        return true;
    }
    searchmode = false;

    if(eline == -1){
        editline = eline;
        calcdoi();
        display(true);
    }else {
        if(editTimeout) clearTimeout(editTimeout);
            editTimeout = setTimeout(longmousedown,300);
        }
    }
);
