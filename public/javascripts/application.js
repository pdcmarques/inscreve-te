// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
addEvent = function(o, e, f, s){
    var r = o[r = "_" + (e = "on" + e)] = o[r] || (o[e] ? [[o[e], o]] : []), a, c, d;
    r[r.length] = [f, s || o], o[e] = function(e){
        try{
            (e = e || event).preventDefault || (e.preventDefault = function(){e.returnValue = false;});
            e.stopPropagation || (e.stopPropagation = function(){e.cancelBubble = true;});
            e.target || (e.target = e.srcElement || null);
            e.key = (e.which + 1 || e.keyCode + 1) - 1 || 0;
        }catch(f){}
        for(d = 1, f = r.length; f; r[--f] && (a = r[f][0], o = r[f][1], a.call ? c = a.call(o, e) : (o._ = a, c = o._(e), o._ = null), d &= c !== false));
        return e = null, !!d;
    }
};

removeEvent = function(o, e, f, s){
    for(var i = (e = o["_on" + e] || []).length; i;)
        if(e[--i] && e[i][0] == f && (s || o) == e[i][1])
            return delete e[i];
    return false;
};


enterAsTab = function(f, a){
	addEvent(f, "keypress", function(e){
		var l, i, f, j, o = e.target;
		if(e.key == 13 && (a || !/textarea|select/i.test(o.type))){
			for(i = l = (f = o.form.elements).length; f[--i] != o;);
			for(j = i; (j = (j + 1) % l) != i && (!f[j].type || f[j].disabled || f[j].readOnly || f[j].type.toLowerCase() == "hidden"););
			e.preventDefault(), j != i && f[j].focus();
                }
        })
  }
  
  
function selectValueSet(selectId, value) {
    eval('selectObject = document.getElementById("' + selectId + '");');
    for(index = 0; index < selectObject.length; index++) {
       if(selectObject[index].value == value)
          selectObject.selectedIndex = index;
    }
}


function isBrowserIE() {
    var browser=navigator.appName;
    var b_version=navigator.appVersion
    if(browser=="Microsoft Internet Explorer" && b_version <= 4){
	return true;
    }
    return false;
}

function formatCurrency(num) {
  if(isNaN(num))
   num = "0";
   
  num = num.toString().replace(/\Û|\,/g,'');
  
  sign = (num == (num = Math.abs(num)));
  num = Math.floor(num*100+0.50000000001);
  cents = num%100;
  num = Math.floor(num/100).toString();
  if(cents<10)
   cents = "0" + cents;
  for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
    num = num.substring(0,num.length-(4*i+3))+','+num.substring(num.length-(4*i+3));
  
  return (((sign)?'':'-') + num + '.' + cents + ' &euro;');
}
				