<h1>This is my portfolio project for Computer Arch and Assembly language</h1>

<p>The main thing I took away from this class is a low level understanding for how programming works and an appreciation for the debugger.  This class was difficult.  It required me to learn new abstract concepts and to implement them in a language that was very difficult and I didn't know.<br>
The project was called String Primitives and Macros and it was an amalgamation of everything we learned in the class with a focus on string primitives and macros.  Below is criteria.  
</p>

<h4><strong>Program Description</strong></h4>
<ul>
<li>Implement and test two <strong>macros</strong> for string processing. These macros should use Irvine’s <code style="color: black; background-color: #eeeeff;"><strong>ReadString</strong></code> to get input from the user, and <code style="color: black; background-color: #eeeeff;"><strong>WriteString</strong></code> procedures to display output.
<ul>
<li><code style="color: black; background-color: #eeeeff;"><strong>mGetString</strong></code>:&nbsp; Display a prompt <em>(input parameter, by reference</em>), then get the user’s keyboard input into a memory location <em>(output parameter, by reference</em>). You may also need to provide a&nbsp;count <em>(input parameter, by value)</em> for the length of input string you can accommodate and a provide a number of bytes read (<em>output parameter, by reference)</em> by the macro.</li>
<li><code style="color: black; background-color: #eeeeff;"><strong>mDisplayString</strong></code>:&nbsp; Print the string which is stored in a specified memory location <em>(input parameter, by reference</em>).</li>
</ul>
</li>
<li>Implement and test two <strong>procedures</strong> for signed integers which use string primitive instructions
<ul>
<li><code style="color: black; background-color: #eeeeff;"><strong>ReadVal</strong></code>:&nbsp;
<ol>
<li>Invoke the <code style="color: black; background-color: #eeeeff;"><strong>mGetString</strong></code> macro (see parameter requirements above) to get user input&nbsp;in the form of a string of digits.</li>
<li>Convert (using string primitives) the string of ascii digits to its numeric value representation (SDWORD), validating the user’s input is a valid number (no letters, symbols, etc).</li>
<li>Store this one value in a memory variable <em>(output parameter, by reference).&nbsp;</em></li>
</ol>
</li>
<li><code style="color: black; background-color: #eeeeff;"><strong>WriteVal</strong></code>:&nbsp;
<ol>
<li>Convert a numeric SDWORD value <em>(input parameter, by value</em>)<i> </i>to a string of ASCII digits.</li>
<li>Invoke the <code style="color: black; background-color: #eeeeff;"><strong>mDisplayString</strong></code> macro to print the ASCII representation of the SDWORD value to the output.</li>
</ol>
</li>
</ul>
</li>
<li>Write a test program (in <code style="color: black; background-color: #eeeeff;"><strong>main</strong></code>) which uses the <code style="color: black; background-color: #eeeeff;"><strong>ReadVal</strong></code> and <code style="color: black; background-color: #eeeeff;"><strong>WriteVal</strong></code> procedures above to:
<ol>
<li>Get 10 valid integers from the user. Your <code style="color: black; background-color: #eeeeff;"><strong>ReadVal</strong></code> will be called within the loop in <code style="color: black; background-color: #eeeeff;"><strong>main</strong></code>. Do not put your counted loop within <code style="color: black; background-color: #eeeeff;"><strong>ReadVal</strong></code>.</li>
<li>Stores these numeric values in an array.</li>
<li>Display the integers, their sum, and their truncated average.</li>
</ol>
</li>
<li>Your <code style="color: black; background-color: #eeeeff;"><strong>ReadVal</strong></code> will be called within the loop in <code style="color: black; background-color: #eeeeff;"><strong>main</strong></code>. Do not put your counted loop within <code style="color: black; background-color: #eeeeff;"><strong>ReadVal</strong></code>.</li>
</ul>

<h4><strong>Program Requirements</strong></h4>

<ol>
<li>User’s numeric input <strong>must</strong> be validated the hard way:
<ol type="a">
<li>Read the user's input as a string and&nbsp;convert the string to numeric form.</li>
<li>If the user enters non-digits other than something which will indicate sign (e.g. ‘+’ or ‘-‘), or the number is too large for 32-bit registers, an error message should be displayed and the number should be discarded.</li>
<li>If the user enters nothing (empty input), display an error and re-prompt.</li>
</ol>
</li>
<li><code style="color: black; background-color: #eeeeff;"><strong>ReadInt</strong></code>,&nbsp;<code style="color: black; background-color: #eeeeff;"><strong>ReadDec</strong></code>,&nbsp;<code style="color: black; background-color: #eeeeff;"><strong>WriteInt</strong></code>, and <code style="color: black; background-color: #eeeeff;"><strong>WriteDec</strong></code> are <strong>not allowed</strong> in this program.</li>
<li><code style="color: black; background-color: #eeeeff;"><strong>mDisplayString</strong></code>&nbsp;must be used to display all strings.</li>
<li>Conversion routines <strong>must</strong> appropriately use the <code style="color: black; background-color: #eeeeff;"><strong>LODSB</strong></code> and/or <code style="color: black; background-color: #eeeeff;"><strong>STOSB</strong></code> operators for dealing with strings.</li>
<li>All procedure parameters <strong>must</strong> be passed on the runtime stack using the <strong>STDCall</strong> calling convention. Strings also <strong>must</strong> be passed by reference.</li>
<li>Prompts, identifying strings, and other memory locations <strong>must</strong> be passed by address to the macros.</li>
<li>Used registers <strong>must</strong> be saved and restored by the called procedures and macros.</li>
<li>The stack frame <strong>must</strong> be cleaned up by the <strong>called</strong> procedure.</li>
<li>Procedures (except <code style="color: black; background-color: #eeeeff;"><strong>main</strong></code>) <strong>must not</strong> reference data segment variables by name.&nbsp;There is a <strong>significant </strong>penalty attached to violations of this rule.&nbsp; Some global constants (properly defined using EQU, =, or TEXTEQU and not redefined) are allowed. These <strong>must</strong> fit the proper role of a constant in a program (master values used throughout a program which, similar to <code style="color: black; background-color: #eeeeff;"><strong>HI</strong></code>&nbsp;and <code style="color: black; background-color: #eeeeff;"><strong>LO</strong></code> in Project 5).</li>
<li>The program <strong>must</strong> use <em>Register Indirect</em> addressing or string primitives (e.g. STOSD) for integer (SDWORD) array elements, and <em>Base+Offset</em> addressing for accessing parameters on the runtime stack.</li>
<li>Procedures <strong>may</strong> use local variables when appropriate.</li>
<li>The program <strong>must</strong> be fully documented and laid out according to the <span class="ally-file-link-holder link_holder"><span class="instructure_file_holder link_holder instructure_file_link_holder ally-file-link-holder">
    
</div></span></span>. This includes a complete header block for identification, description, etc., a comment outline to explain each section of code, and proper procedure headers/documentation.</li>
</ol>
