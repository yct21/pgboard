module.exports = {
    "parser": "babel-eslint",

    "env": {
        "es6": true,
        "browser": true,
    },

    "ecmaFeatures": {
        "arrowFunctions": true,
        "binaryLiterals": true,
        "blockBindings": true,
        "classes": true,
        "defaultParams": true,
        "destructuring": true,
        "modules": true,
        "objectLiteralComputedProperties": true,
        "objectLiteralDuplicateProperties": true,
        "objectLiteralShorthandMethods": true,
        "objectLiteralShorthandProperties": true,
        "restParams": true,         // Indicated by three dots (...). That named parameter becomes an Array containing the rest of the parameters passed to the function.
        "superInFunctions": true,
        "templateStrings": true,    // Used inside of `` type quotes.
        "jsx": true,
    },

    "plugins": ["react"],

    // Map from global var to bool specifying if it can be redefined
    "globals": {
        "__dirname": false,
        "cancelAnimationFrame": false,
        "clearImmediate": true,
        "clearInterval": false,
        "clearTimeout": false,
        "console": false,
        "document": false,
        "escape": false,
        "exports": false,
        "fetch": false,
        "global": false,
        "jest": false,
        "Map": true,
        "module": false,
        "navigator": false,
        "process": false,
        "Promise": true,
        "requestAnimationFrame": true,
        "require": false,
        "Set": true,
        "setImmediate": true,
        "setInterval": false,
        "setTimeout": true,
        "window": true,
        "XMLHttpRequest": false,
        "pit": false
    },

    "rules": {

        /* Possible Errors */
        "comma-dangle": 0,
        "no-console": 0,
        "no-debugger": 1,
        "no-dupe-keys": 2,
        "no-dupe-args": 2,
        "no-ex-assign": 2,
        "no-extra-boolean-cast": 1,
        "no-extra-parens": 0,
        "no-extra-semi": 1,
        "no-invalid-regexp": 1,
        "no-negated-in-lhs": 1,
        "no-obj-calls": 1,
        "no-regex-spaces": 1,
        "no-reserved-keys": 0,
        "no-sparse-arrays": 1,
        "no-unreachable": 1,
        "use-isnan": 1,
        "valid-jsdoc": 0,
        "valid-typeof": 1,

        /* Best Practices */
        "accessor-pairs": [1, {"getWithoutSet": true}], // Enforces getter/setter pairs in objects
        "block-scoped-var": 0,           // treat var statements as if they were block scoped (off by default)
        "complexity": 0,                 // specify the maximum cyclomatic complexity allowed in a program (off by default)
        "consistent-return": 0,          // require return statements to either always or never specify values
        "curly": 1,                      // specify curly brace conventions for all control statements
        "default-case": 0,               // require default case in switch statements (off by default)
        "dot-location": [1, "property"], // enforces consistent newlines before or after dots
        "dot-notation": 1,               // encourages use of dot notation whenever possible
        "eqeqeq": [1, "smart"],          // require the use of === and !==
        "guard-for-in": 0,               // make sure for-in loops have an if statement (off by default)
        "no-alert": 1,                   // disallow the use of alert, confirm and prompt
        "no-caller": 1,                  // disallow use of arguments.caller or arguments.callee
        "no-case-declarations": 1,       // disallow lexical declarations in case clauses
        "no-div-regex": 1,               // disallow division operators explicitly at beginning of regular expression (off by default)
        "no-else-return": 0,             // disallow else after a return in an if (off by default)
        "no-eq-null": 0,                 // disallow comparisons to null without a type-checking operator (off by default)
        "no-eval": 1,                    // disallow use of eval()
        "no-extend-native": 1,           // disallow adding to native types
        "no-extra-bind": 1,              // disallow unnecessary function binding
        "no-fallthrough": 1,             // disallow fallthrough of case statements
        "no-floating-decimal": 1,        // disallow the use of leading or trailing decimal points in numeric literals (off by default)
        "no-implicit-coercion": 1,       // disallow the type conversions with shorter notations
        "no-implied-eval": 1,            // disallow use of eval()-like methods
        "no-invalid-this": 1,            // disallow this keywords outside of classes or class-like objects
        "no-iterator": 1,                // disallow usage of __iterator__ property
        "no-labels": 1,                  // disallow use of labeled statements
        "no-lone-blocks": 1,             // disallow unnecessary nested blocks
        "no-loop-func": 0,               // disallow creation of functions within loops
        "no-magic-numbers": 0,           // disallow the use of magic numbers
        "no-multi-spaces": 1,            // disallow use of multiple spaces (fixable)
        "no-multi-str": 0,               // disallow use of multiline strings
        "no-native-reassign": 0,         // disallow reassignments of native objects
        "no-new-func": 1,                // disallow use of new operator for Function object
        "no-new-wrappers": 1,            // disallows creating new instances of String,Number, and Boolean
        "no-new": 1,                     // disallow use of new operator when not part of the assignment or comparison
        "no-octal-escape": 1,            // disallow use of octal escape sequences in string literals, such as var foo = "Copyright \251";
        "no-octal": 1,                   // disallow use of octal literals
        "no-param-reassign": 1,          // disallow reassignment of function parameters
        "no-process-env": 0,             // disallow use of process.env in Node.js
        "no-proto": 1,                   // disallow usage of __proto__ property
        "no-redeclare": 0,               // disallow declaring the same variable more then once
        "no-return-assign": 1,           // disallow use of assignment in return statement
        "no-script-url": 1,              // disallow use of javascript: urls.
        "no-self-compare": 1,            // disallow comparisons where both sides are exactly the same (off by default)
        "no-sequences": 0,               // disallow use of comma operator
        "no-throw-literal": 1,           // restrict what can be thrown as an exception
        "no-unused-expressions": 0,      // disallow usage of expressions in statement position
        "no-useless-call": 1,            // disallow unnecessary .call() and .apply()
        "no-useless-concat": 1,          // disallow unnecessary concatenation of literals or template literals
        "no-void": 1,                    // disallow use of void operator (off by default)
        "no-warning-comments": 0,        // disallow usage of configurable warning terms in comments: 1,  // e.g. TODO or FIXME (off by default)
        "no-with": 1,                    // disallow use of the with statement
        "radix": 1,                      // require use of the second argument for parseInt() (off by default)
        "vars-on-top": 0,                // requires to declare all vars on top of their containing scope (off by default)
        "wrap-iife": 0,                  // require immediate function invocation to be wrapped in parentheses (off by default)
        "yoda": 1,                       // require or disallow Yoda conditions

        /* Strict Mode */
        "strict": [2, "global"],

        /* Variables */
        "no-undef": 2,
        "no-undef-init": 1,
        "no-unused-vars": [1, {"vars": "all", "args": "none"}], // disallow declaration of variables that are not used in the code
        "no-shadow-restricted-names": 1,

        /* Stylistic Issues */
        "camelcase": [1, {"properties": "never"}],
        "eol-last": 1,
        "indent": [2, 2],
        "quotes": [2, "double", "avoid-escape"],
        "linebreak-style": [1, "unix"],
        "new-parens": 1,
        "no-trailing-spaces": 1,
        "semi": [2, "never"],
        "semi-spacing": 1,               // require a space after a semi-colon
        "keyword-spacing": 1,
        "space-infix-ops": 1,

        /* ECMAScript 6 */
        "no-class-assign": 2,
        "object-shorthand": 0,

        /* React Issues */
        "react/display-name": 1,          // Prevent missing displayName in a React component definition
        "react/forbid-prop-types": 1,     // Forbid certain propTypes
        "react/jsx-boolean-value": 1,     // Enforce boolean attributes notation in JSX (fixable)
        "react/jsx-closing-bracket-location": 0,  // Validate closing bracket location in JSX
        "react/jsx-curly-spacing": 1,     // Enforce or disallow spaces inside of curly braces in JSX attributes (fixable)
        "react/jsx-equals-spacing": 1,    // Enforce or disallow spaces around equal signs in JSX attributes
        "react/jsx-handler-names": 1,     // Enforce event handler naming conventions in JSX
        "react/jsx-indent-props": [2, 2],  // Validate props indentation in JSX
        "react/jsx-indent": [2, 2],   // Validate JSX indentation
        "react/jsx-key": 0,               // Validate JSX has key prop when in array or iterator
        "react/jsx-no-bind": [1, { "ignoreRefs": false, "allowArrowFunctions": true, "allowBind": true }],  // Prevent usage of .bind() and arrow functions in JSX props
        "react/jsx-no-duplicate-props": 1,  // Prevent duplicate props in JSX
        "react/jsx-no-literals": 0,       // Prevent usage of unwrapped JSX strings
        "react/jsx-no-undef": 1,          // Disallow undeclared variables in JSX
        "react/jsx-pascal-case": 1,       // Enforce PascalCase for user-defined JSX components
        "react/jsx-quotes": 0,            // DEPRECATED - Enforce quote style for JSX attributes
        "react/jsx-sort-prop-types": 0,   // Enforce propTypes declarations alphabetical sorting
        "react/jsx-sort-props": 0,        // Enforce props alphabetical sorting
        "react/jsx-uses-react": 1,        // Prevent React to be incorrectly marked as unused
        "react/jsx-uses-vars": 1,         // Prevent variables used in JSX to be incorrectly marked as unused
        "react/no-danger": 1,             // Prevent usage of dangerous JSX properties
        "react/no-deprecated": 1,         // Prevent usage of deprecated methods
        "react/no-did-mount-set-state": [1, "allow-in-func"],   // Prevent usage of setState in componentDidMount
        "react/no-did-update-set-state": [1, "allow-in-func"],  // Prevent usage of setState in componentDidUpdate
        "react/no-direct-mutation-state": 1,                    // Prevent direct mutation of this.state
        "react/no-is-mounted": 1,         // Prevent usage of isMounted
        "react/no-multi-comp": 0,         // Prevent multiple component definition per file
        "react/no-set-state": 1,          // Prevent usage of setState
        "react/no-string-refs": 1,        // Prevent using string references in ref attribute.
        "react/no-unknown-property": 1,   // Prevent usage of unknown DOM property (fixable)
        "react/prefer-es6-class": 1,      // Enforce ES5 or ES6 class for React Components
        "react/prop-types": 0,            // Prevent missing props validation in a React component definition
        "react/react-in-jsx-scope": 1,    // Prevent missing React when using JSX
        "react/require-extension": 1,     // Restrict file extensions that may be required
        "react/self-closing-comp": 1,     // Prevent extra closing tags for components without children
        "react/sort-comp": 1,             // Enforce component methods order
        "react/wrap-multilines": [1, {"declaration": false, "assignment": false, "return": true}],  // Prevent missing parentheses around multilines JSX (fixable)

    }

}
