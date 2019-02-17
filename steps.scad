/**
 * KEY ELEMENTS DESCRIPTION:
 * -------------------------
 *
 * STAIR:
 * ------
 * Single stair. Front view will be like ARC, side view will be like:
 *
 *   _________________________
 *  /                     ___/
 * |                  ___/
 *  \             ___/
 *   |        ___/
 *   |    ___/
 *   |___/
 *
 * Please note rounding at front part of stair
 * Stair itself is created by extruding ARC along spiral segment
 *
 */

include <common.scad>

module steps(first_step, last_step) {
    steps_count = last_step - first_step;
    union () {
        difference() {
            // stair spiral with supporting arc
            translate([0, 0, first_step * step_height])
                rotate([0, 0, first_step * step_angle])
                    extrude_2dpath_along_spiral(
                        arc,
                        h = step_height * steps_count,
                        r = wall_thickness,
                        twist = step_angle * steps_count + step_extra_angle,
                        $fn = spiral_details);
            for (i = [first_step:last_step - 1]) {
                z_offset = arc_height + i * step_height;
                // cut off top of stair, make spiral flat
                rotate([0, 0, step_angle * (i + 1) - 90])
                    translate([0, 0, z_offset])
                        cube([tower_radius * 2, tower_radius * 2, step_height]);
                // cut off slot for rounding
                rotate([0, 0, step_angle * i])
                    translate([0, -step_rounding_offset, z_offset - step_rounding_r])
                        cube([tower_radius * 2, step_rounding_r, step_rounding_r]);
            }
            // flatten last stair
            rotate([0, 0, step_angle * last_step + step_extra_angle * 2 - 90])
                translate([0, 0, arc_height + (last_step - 1) * step_height])
                    cube([tower_radius * 2, tower_radius * 2, step_height * 2]);
        }
        // steps roundings
        for (i = [first_step:last_step - 1])
            rotate([0, 0, step_angle * i])
                translate([wall_thickness - step_rounding_extra / 2, step_rounding_r - step_rounding_offset, arc_height - step_rounding_r + i * step_height]) rotate([0, 90, 0]) cylinder(r = step_rounding_r, h = arc_width + step_rounding_extra, $fn = step_rounding_details);
    }
}

