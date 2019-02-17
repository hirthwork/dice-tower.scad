include <common.scad>

rock_min_size = 20;
rock_max_size = 40;

rock_min_x_angle = -15;
rock_max_x_angle = 15;
rock_min_y_angle = 5;
rock_max_y_angle = 30;
rock_min_z_angle = -30;
rock_max_z_angle = 30;

rock_min_rounding_r = 0.5;
rock_max_rounding_r = 5;

rock_angle = 20;
outer_rock_angle = 15;
rock_offset = rock_min_size / 2;
outer_rock_offset = rock_offset + tower_radius / 4;
// skip rocks at entrance
rocks_count = 300 / rock_angle;
outer_rocks_count = 300 / outer_rock_angle;

rocks_intersected = 5;

module rock(n) {
    sizes = rands(rock_min_size, rock_max_size, rocks_intersected * 3, n);
    x_angles = rands(rock_min_x_angle, rock_max_x_angle, rocks_intersected, n * 2);
    y_angles = rands(rock_min_y_angle, rock_max_y_angle, rocks_intersected, n * 3);
    z_angles = rands(rock_min_z_angle, rock_max_z_angle, rocks_intersected, n * 4);
    rounding_r = rands(rock_min_rounding_r, rock_max_rounding_r, 1, n * 5)[0];
    minkowski() {
        intersection_for(i = [0 : rocks_intersected - 1]) {
            rotate([x_angles[i], -y_angles[i], z_angles[i]])
                cube([sizes[i * 3] / 2, sizes[i * 3 + 1], sizes[i * 3 + 2] * 3], true);
        }
        sphere(r = rounding_r, $fn = brick_rounding_details);
    }
}

