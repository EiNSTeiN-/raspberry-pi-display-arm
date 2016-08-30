$fn=200;

clip_plate = 18;
clip_height = 44;
clip_tab = 20;
clip_junction_side = 10;
clip_side = 4;
clip_dia = clip_side + clip_plate + clip_side;

screw_dia=4.5;
screw_head_dia=8.5;
screw_head_height=4;

print();
//display();

module print()
{
    translate([20, 0, 0]) clip();
    translate([-20, 0, 0]) mirror([1, 0, 0]) clip();

    translate([40, 40, 0]) rotate([0, 0, 90]) translate([0, 0, 0]) arm();
    translate([0, -40, 0]) pivot();

    translate([5, 30, 0]) union() {
        clamp_full();
        translate([-20, 20, 0]) clamp_half();
    }
}


module display()
{
    translate([20, 0, 0]) clip();
    translate([20, 0, clip_height]) mirror([0, 0, 1]) clip();

    translate([clip_dia+20, -clip_dia/2, clip_junction_side]) rotate([0, 0, 200]) union() {
        arm();
        translate([0, arm_length, arm_height/2]) rotate([15, 0, 0]) union() {
            translate([-arm_opening_width/2, 0, 0]) rotate([0, 90, 0]) pivot();
            translate([0, clip_dia/2 + arm_opening_width + 10, 0]) rotate([180, 0, 0]) 
                translate([0, -clamp_thickness, -clamp_height/2]) clamp_full();
            translate([0, clip_dia/2 + arm_opening_width + 10, 0]) rotate([0, -90, 180]) 
                translate([0, -clamp_thickness, -clamp_height/2]) clamp_half();
        }
    }
}


module clip()
{
    difference() {
        hull() {
            translate([-clip_dia/2, 0, 0]) cube([clip_dia, clip_tab, clip_height/2]);
            translate([clip_dia, -clip_dia/2, 0]) cylinder(r=clip_dia/2, h=clip_height/2);
        }
        union() {
            translate([-clip_plate/2, clip_side, -1]) cube([clip_plate, clip_tab-clip_side+1, clip_height/2+2]);
            hull() {
                translate([0, -clip_dia/2, clip_junction_side]) 
                    cylinder(r=clip_dia/2+0.1, h=clip_height-clip_junction_side*2);
                translate([clip_dia, -clip_dia/2, clip_junction_side]) 
                    cylinder(r=clip_dia/2+0.1, h=clip_height-clip_junction_side*2);
            }
            hull() {
                translate([clip_dia, -clip_dia/2, clip_junction_side]) 
                    cylinder(r=clip_dia/2+0.1, h=clip_height-clip_junction_side*2);
                translate([clip_dia, clip_dia/2, clip_junction_side]) 
                    cylinder(r=clip_dia/2+0.1, h=clip_height-clip_junction_side*2);
            }
            for(r=[1, -1]) translate([r*(clip_plate/2-0.1), clip_tab/2, clip_height/4]) rotate([0, r*90, 0]) {
                cylinder(r1=5/2, r2=9/2, h=4);
                translate([0, 0, 4-0.1]) cylinder(r=9/2, h=20);
            }
            translate([clip_dia, -clip_dia/2, -1]) cylinder(r=screw_dia/2, h=clip_height+2);
            translate([clip_dia, -clip_dia/2, clip_height-screw_head_height]) cylinder(r=screw_head_dia/2, h=screw_head_height+1);
        }
    }
}

arm_length = 70;
arm_width = clip_dia;
arm_height = clip_height - clip_junction_side*2;
arm_opening_width = arm_width - clip_side*2;
ball_dia = 20;

module arm()
{
    difference() {
        hull() {
            translate([-clip_dia/2, 0, 0]) cube([clip_dia, arm_length, arm_height]);
            translate([0, 0, 0]) cylinder(r=clip_dia/2, h=arm_height);
            translate([-clip_dia/2, arm_length, arm_height/2]) rotate([0, 90, 0]) cylinder(r=arm_height/2, h=clip_dia);
        }
        union() {
            difference() {
                translate([-arm_opening_width/2, 0, -1]) 
                    cube([arm_opening_width, arm_length+arm_height/2+1, arm_height+2]);
                translate([0, 0, 0]) cylinder(r=clip_dia/2, h=arm_height);
                translate([-clip_dia/2, -clip_side+arm_length-arm_height/2-10, 0]) cube([clip_dia, clip_side, arm_height]);
            }
            
            translate([0, 0, -1]) cylinder(r=screw_dia/2, h=arm_height+2);
            
            translate([-clip_dia/2-1, arm_length, arm_height/2])  rotate([0, 90, 0]) cylinder(r=screw_dia/2, h=clip_dia+2);
            translate([clip_dia/2-2, arm_length, arm_height/2]) rotate([0, 90, 0]) cylinder(r=8/2, h=3+1, $fn=6);
        }
    }
}

module pivot()
{
    intersection() {
        difference() {
            hull() {
                translate([0, 0, 0]) cylinder(r=clip_dia/2, h=arm_opening_width);
                translate([-clip_dia/2, (clip_dia + arm_opening_width)/2, arm_opening_width/2]) rotate([0, 90, 0]) cylinder(r=arm_opening_width/2, h=clip_dia);
            }
            union() {
                translate([0, 0, -1]) cylinder(r=screw_dia/2, h=arm_opening_width+2);
                translate([0, -clip_dia/2-1, arm_opening_width/2]) rotate([-90, 0, 0]) 
                    cylinder(r=screw_dia/2, h=(clip_dia + arm_opening_width)+2);
                translate([0, clip_dia/2, arm_opening_width/2]) rotate([90, 0, 0]) 
                    cylinder(r=screw_head_dia/2, h=(clip_dia + arm_opening_width)+2);
                translate([0, clip_dia/2 + arm_opening_width + 1, arm_opening_width/2]) rotate([90, 0, 0]) 
                    cylinder(r=8/2, h=3+1, $fn=6);
            }
        }
    }
}


screen_width = 115;
screen_board_thickness = 20;
screen_board_width = 90;
screen_thickness = 10;

clamp_height = 20;
clamp_wall = 3;
clamp_width = clamp_wall + screen_width + clamp_wall;
clamp_thickness = clamp_wall + screen_thickness + screen_board_thickness + clamp_wall;

module clamp_full()
{
    difference() {
        union() {
            translate([-clamp_width/2+2, 2, 0]) minkowski() {
                cube([clamp_width-2*2, clamp_thickness-2*2, clamp_height]);
                cylinder(r=2, h=0.1);
            }
        }
        union() {
            hull() {
                translate([-screen_board_width/2, clamp_wall, -1]) 
                    cube([screen_board_width, (clamp_thickness-clamp_wall*2), clamp_height+2]);
                translate([-screen_board_width/2-10/2, clamp_wall, 0]) translate([0, 0, -1]) 
                    cube([screen_board_width+10, screen_thickness, clamp_height+2]);
            }
            translate([-screen_width/2, clamp_wall, 0]) translate([0, 0, -1]) 
                cube([screen_width, screen_thickness, clamp_height+2]);
            translate([-(clamp_width-clamp_wall*2-8)/2, -1, -1]) cube([clamp_width-clamp_wall*2-8, clamp_wall+2, clamp_height+2]);
            translate([0, clamp_thickness-clamp_wall-1, clamp_height/2]) rotate([-90, 0, 0]) cylinder(r=screw_dia/2, h=20);
            translate([0, clamp_thickness-clamp_wall-1, clamp_height/2]) rotate([-90, 0, 0]) cylinder(r=8/2, h=3+1, $fn=6);
        }
    }
}

module clamp_half()
{
    difference() {
        union() {
            translate([-clamp_width/2+2, 2, 0]) minkowski() {
                cube([clamp_width/2+2+clamp_height/2, clamp_thickness+clamp_wall-2*2, clamp_height]);
                cylinder(r=2, h=0.1);
            }
        }
        union() {
            translate([-clamp_height/2, 0, -1]) cube([clamp_height, clamp_thickness, clamp_height+2]);
            hull() {
                translate([-screen_board_width/2, clamp_wall, -1]) 
                    cube([screen_board_width, (clamp_thickness-clamp_wall*2), clamp_height+2]);
                translate([-screen_board_width/2-10/2, clamp_wall, 0]) translate([0, 0, -1]) 
                    cube([screen_board_width+10, screen_thickness, clamp_height+2]);
            }
            translate([-screen_width/2, clamp_wall, 0]) translate([0, 0, -1]) 
                cube([screen_width, screen_thickness, clamp_height+2]);
            translate([-(clamp_width-clamp_wall*2-8)/2, -1, -1]) cube([clamp_width-clamp_wall*2-8, clamp_wall+2, clamp_height+2]);
            translate([0, clamp_thickness-clamp_wall-1, clamp_height/2]) rotate([-90, 0, 0]) cylinder(r=screw_dia/2, h=20);
        }
    }
}