var isVisible = false;

function showLogin()
{
    var el = $("loginform");

    if (isVisible)
    {
	el.style.display = 'none';
	isVisible = false;
    }
    else
    {
	el.style.display = '';
	isVisible = true;
    }
}

var myobj = function ()
{

    var config = {
    colors: [ 'red', 'green', 'blue']
    }

    var foo = function ()
    {
	alert('here is foo');
    }

    return {
    myconfig: config,
    myfoo: foo
    };
}();

//myobj.myfoo();

var myobj2 = {
mybar: function()
{
    alert('here is bar');
}
};

//myobj2.mybar();
