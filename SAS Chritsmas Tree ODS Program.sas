* SAS ODS Graphics take on Happy-Holidays-From-SAS tree;

data treepoints;                                     * Get dimensions, colors of SAS tree image circles;
infile cards truncover;                              * Dimensions obtained from MS-Paintbrush (x/y values);
input centerX centerY topY color : $12.;             * Origin of circle (x/y), top of circle (y), color;
maxradius=centerY-topY;                              * Compute radius;
Height=521;                                          * Convert y-values from 0=top to 0=bottom;                                     
topy=height-topy;
centerY=height-centerY;
subcircle=1;                                         * Subcircles 1-5 are opaque, 6-8 semi-transparent;
blank="";
do radius=maxradius*.3 to maxradius by maxradius*.1; * Eight subcircles per circle;  
  circle+1;
  output;
  subcircle+1;
end;  
cards;
196 47 5 GOLD
195 114 88 GREEN
205 168 123 RED
156 174 162 YELLOW
157 209 177 BLUE
251 202 182 YELLOWGREEN
203 259 205 ORANGE
126 281 241 GREEN
267 281 252 RED
98 323 302 AQUA
174 337 288 PURPLE
245 317 293 YELLOW
293 317 302 BLUE
98 373 331 ORANGE
267 382 327 DODGERBLUE
64 423 392 YELLOW
160 427 368 RED
319 399 389 YELLOW
37 459 439 YELLOWGREEN
90 476 444 BLUE
230 462 435 YELLOWGREEN
312 452 392 GREEN
;
data treepoints;                                     
set treepoints end=eof;
if maxradius<20 then thickness="1.5pt";              * Vary line thickness based on radius;
else if maxradius <30 then thickness="2.5pt";
else thickness="3pt";
length attrmap $ 32000; retain attrmap '';           * Build attribute map of colors, line thicknesses;
attrmap=trim(attrmap)||" value '"||compress(put(circle,3.))||
        "' / lineattrs=(thickness=" || thickness || " pattern=shortdash color=" ||trim(color)||");";
                                                     * Create new variables for outermost subcircles;
if      subcircle=6 then do; circle6=circle; circle=.; end;
else if subcircle=7 then do; circle7=circle; circle=.; end;
else if subcircle=8 then do; circle8=circle; circle=.; end;       
output; 
if eof;
call symput('attrmap', attrmap);                     * Create macro variable with attribute map;
put attrmap=;                                        * Sneak a peek;
                                                     * Let's make a tree!;
ods listing image_dpi=300 gpath='/folders/myfolders'; 
ods graphics on / reset antialias width=8.5in height=11in imagename="sasxmastree";
proc template;
define statgraph ellipseparm;
begingraph; 
  discreteAttrMap name='TreeColor';                  * Assign colors;
    &attrmap
  endDiscreteAttrMap;                                * Create variables to facilitate different transparency;
  discreteAttrVar attrVar=TreeC var=circle attrMap="TreeColor";
  discreteAttrVar attrVar=TreeC6 var=circle6 attrMap="TreeColor";
  discreteAttrVar attrVar=TreeC7 var=circle7 attrMap="TreeColor";
  discreteAttrVar attrVar=TreeC8 var=circle8 attrMap="TreeColor";
  layout overlayequated / walldisplay=none
    xaxisopts=(display=none offsetmin=0 offsetmax=0)
    yaxisopts=(display=none offsetmin=0 offsetmax=0);                                                     
                                                     * Subcircle transparency: 1-5=0 6=.5 7=.7 9=.8;
    ellipseparm semimajor=radius semiminor=radius slope=0        
      xorigin=centerX yorigin=centerY / datatransparency=0 group=treec INCLUDEMISSINGGROUP=FALSE;
    ellipseparm semimajor=radius semiminor=radius slope=0        
      xorigin=centerX yorigin=centerY / datatransparency=.50 group=treec6 INCLUDEMISSINGGROUP=FALSE;
    ellipseparm semimajor=radius semiminor=radius slope=0        
      xorigin=centerX yorigin=centerY / datatransparency=.70 group=treec7 INCLUDEMISSINGGROUP=FALSE;
    ellipseparm semimajor=radius semiminor=radius slope=0        
      xorigin=centerX yorigin=centerY / datatransparency=.80 group=treec8 INCLUDEMISSINGGROUP=FALSE;
    textplot x=centerX y=centerY text=blank / textattrs=(size=0pt);
  endlayout;
endGraph;
end;
run;
proc sgrender data=treepoints template=ellipseparm;   * Render image!;
run;