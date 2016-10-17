var myApp=angular.module('CalculatorApp', []);

myApp.controller('CalculatorController', function ($scope) {
    $scope.CalculatorDisplay = '';
    var stack = [];
    var iValue1, iValue2, iSum, sOperand;
    var iNumber = 0;
    var bNewNumber = false;
    var sGlobalLastInputted = '';
    var iLastValue;

    $scope.inputNumbers = function (paramValue) {
        if (paramValue == 'Clear')
        {
            stack = [];
            $scope.CalculatorDisplay = '';
            bNewNumber = false;
            return;
        }
        else if(paramValue == 'Toggle')
        {
            $scope.CalculatorDisplay = $scope.CalculatorDisplay * -1;
            return;
        }
        if ((paramValue == '+') || (paramValue == '/') || (paramValue == '*') || (paramValue == '-') || (paramValue == '='))
        {
            /*swap out the last operand with the current operand*/
            var sLastElementOnStack=stack[stack.length-1];
            if ((sLastElementOnStack == '+') || (sLastElementOnStack == '/') || (sLastElementOnStack == '*') || (sLastElementOnStack == '-') )
            {
                if (paramValue != '=')
                {
                    stack[stack.length - 1] = paramValue;
                }
            }
            /*Swap last operand with current operand*/
            if (sGlobalLastInputted != '=') {
                if (IsANumber(sGlobalLastInputted) == false) {
                    sGlobalLastInputted = paramValue;
                    return;
                }
                iNumber = eval($scope.CalculatorDisplay);
                stack.push(iNumber);
            }
            /* equal is press more than once*/
            else {
                if (stack.length < 3)  {
                    sGlobalLastInputted = paramValue;
                    bNewNumber = true;
                    if (sGlobalLastInputted != '=') {
                        stack.push(paramValue);
                        sGlobalLastInputted = '';
                    }
                    return;
                }
            }

            sGlobalLastInputted = paramValue;

            if (stack.length > 2) {
                iValue2 = stack.pop();
                sOperand = stack.pop();
                iValue1 = stack.pop();
                iLastValue = iValue1;
                iSum = parseTotal(iValue1, sOperand, iValue2);
                stack = [];
                stack.push(iSum);


                
                if (paramValue != '=')
                {
                    stack.push(paramValue)
                }
                $scope.CalculatorDisplay = iSum;


                //var log = [];
                //angular.forEach(stack, function (value, key) {
                    //alert(key + ':' + value);
                    //$scope.StackList.push(key + ': ' + value );
                //}, log);

            }
            else
            {
                stack.push(paramValue)
            }
            bNewNumber = true;
        }
            /*A number was input*/
        else
        {
            sGlobalLastInputted = paramValue;
            if (bNewNumber == true)
            {
                $scope.CalculatorDisplay = paramValue;
                bNewNumber = false;
            }
            else
            {
                if (IsANumber($scope.CalculatorDisplay+paramValue.toString()) == true)
                {
                    $scope.CalculatorDisplay = $scope.CalculatorDisplay + paramValue.toString();
                }
                
            }
        }
        
    };
   });

function IsANumber(sVal)
{
    var strText;
    var sData;
    var bPass=false;
    var regx = /^\-{0,1}[0-9]+\.{0,1}[0-9]*$/;
       
    bPass=regx.test(sVal);

    return(bPass);

}
function parseTotal(iValue1,sOperand,iValue2)
{
    var iRetVal = 0;
    if (sOperand=='+')
    {
        iRetVal = iValue1 + iValue2;
    }
    else if (sOperand == '/')
    {
        iRetVal = iValue1 / iValue2;
    }
    else if (sOperand == '*') {
        iRetVal = iValue1 * iValue2;
    }
    else if (sOperand == '-') {
        iRetVal = iValue1 - iValue2;
    }
    return (iRetVal);
}