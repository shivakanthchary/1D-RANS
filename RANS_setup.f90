!-----------------------------------------------------------------------------------!
!
!   PROGRAM : RANS_setup.f90
!
!   PURPOSE : Setup the 1D turbulent channel flow for RANS model
!
!                                                                 2016.11.17 K.Noh
!
!-----------------------------------------------------------------------------------!

        SUBROUTINE SETUP

            USE RANS_module,                                                    &
                ONLY : Ny, del, dy, Re_tau, nu, u_tau,                          &
                       A1, A4, B0, C1, Cd, Cm, Cp, Ct, Ce, Ce1, Ce2, Sk, Se,    &
                       itmax, resi, tol, mode, alpha, beta

            USE RANS_module,                                                    &
                ONLY : U, U_exac, U_new, Y, k, k_new, dis, dis_new, nu_T, prod, &
                       fm, fw, Rt

            IMPLICIT NONE
            INTEGER :: j

            !-----------------------------------------------------------!
            !                 Constants for simulation
            !-----------------------------------------------------------!
            itmax = 50000000       ! maximum interation number
            resi = 0.              ! criteria for convergence
            tol = 1e-10            ! tolerance for convergence

            Ny  = 200              ! the number of grid cells
            del = 1.               ! the channel-half height
            dy  = del/Ny           ! grid size

            Re_tau = 180.          ! Reynolds number based on friction velocity
            nu     = 3.5000e-4     ! Kinematic viscosity of reference data
            u_tau  = Re_tau*nu/del ! Friction velocity

            !-----------------------------------------------------------!
            !             Damping function mode for k-e model
            !
            !    mode = 0 : No damping function
            !         = 1 : Van Driest (1954)
            !         = 2 : Launder and Sharma (1974)
            !         = 3 : Lam and Bremhorst (1981)
            !         = 4 : Park et al (1997)
            !-----------------------------------------------------------!
            mode = 4

            !-----------------------------------------------------------!
            !                   Constants for k-e model
            !-----------------------------------------------------------!

            A1  = 60.
            A4  = 10.
            B0  = 0.25
            C1  = 0.4
            Cd  = 20.
            Cp  = 0.2
            Ce  = 70.
            Ct  = 6.

            IF (mode == 4) THEN
              Cm  = 0.09
              Ce1 = 1.45
              Ce2 = 1.8
              Sk  = 1.2
              Se  = 1.3
            ELSE
              Cm  = 0.09
              Ce1 = 1.44
              Ce2 = 1.92
              Sk  = 1.0
              Se  = 1.3
            END IF

            !-----------------------------------------------------------!
            !                     Relaxation factors
            !-----------------------------------------------------------!
            alpha = 0.3
            beta  = 0.3

            ALLOCATE( U(0:NY),U_new(0:Ny),U_exac(0:Ny),Y(0:Ny),prod(0:Ny) )
            ALLOCATE( k(0:Ny),k_new(0:Ny),dis(0:Ny),dis_new(0:Ny),nu_T(0:Ny) )
            ALLOCATE( fm(0:Ny), fw(0:Ny), Rt(0:Ny) )

            !-----------------------------------------------------------!
            !                      Initial Conditions
            !-----------------------------------------------------------!
            DO j = 0,Ny
              Y(j)        = j*dy
              U(j)        = 0.
              k(j)        = 0.1000
              dis(j)      = 0.0500
              nu_T(j)     = 0.
              prod(j)     = 0.

              fm(j)       = 0.
              fw(j)       = 0.

              k_new(j)    = 0.
              U_new(j)    = 0.
              dis_new(j)  = 0.
              U_exac(j)   = -(nu/(2.*del))*(Re_tau/del)**2.*Y(j)*(Y(j)-2.*del)
            END DO

        END SUBROUTINE SETUP
