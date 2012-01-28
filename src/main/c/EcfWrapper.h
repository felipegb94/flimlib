/* 
This file is part of the SLIM-curve package for exponential curve fitting of spectral lifetime data.

Copyright (c) 2010, 2011, Gray Institute University of Oxford & UW-Madison LOCI.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/* 
 * File:   EcfWrapper.h
 * Author: Aivar Grislis
 *
 * Created on September 3, 2010, 5:21 PM
 */

#ifndef _ECFWRAPPER_H
#define	_ECFWRAPPER_H

#ifdef	__cplusplus
extern "C" {
#endif

int RLD_fit(
        double x_inc,
        double y[],
        int fit_start,
        int fit_end,
        double instr[],
        int n_instr,
        int noise,
        double sig[],
        double *z,
        double *a,
        double *tau,
        double fitted[],
        double *chi_square,
        double chi_square_target
        );

int LMA_fit(
        double x_inc,
        double y[],
        int fit_start,
        int fit_end,
        double instr[],
        int n_instr,
        int noise,
        double sig[],
        double param[],
        int param_free[],
        int n_param,
        double fitted[],
        double *chi_square,
        double chi_square_target,
        double chi_square_delta
        );

#ifdef	__cplusplus
}
#endif

#endif	/* _ECFWRAPPER_H */

