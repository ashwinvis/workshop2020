module moving_average
  implicit none

  integer, parameter:: dp=kind(0.d0)

  type :: timeseries
    integer :: nb_samples, series_size  ! the window and total size
    real(dp), allocatable :: series(:)
  contains
    procedure :: init => timeseries_init
    procedure :: put_value => timeseries_put_value
    procedure :: get_average => timeseries_get_average
  end type

  type, extends(timeseries) :: timestats
    real(dp) :: minimum, maximum, stddev
  contains
    procedure :: calc_stats => timeseries_calc_stats
  end type
contains

  subroutine timeseries_init(self)
    !NOTE: use class below instead of type to allow inheritance
    class(timeseries):: self
    integer :: status

    allocate(self%series(2), stat=status)

    self%series = (/0._dp, 0._dp/)
    self%series_size = size(self%series)
  end subroutine

  subroutine timeseries_calc_stats(self)
    class(timestats):: self

    self%minimum = minval(self%series)
    self%maximum = maxval(self%series)
    self%stddev = 0._dp
  end subroutine

  subroutine timeseries_put_value(self, new_data)
    class(timeseries) :: self
    ! real(dp), dimension(1:old_size) :: old_data
    real(dp), intent(in) :: new_data(:)
    integer :: old_size, new_size

    ! old_data = self%series
    old_size = size(self%series)
    new_size = size(new_data)

    ! NOTE: incomplete
    ! deallocate(self%series)
    ! allocate(self%series(old_size + new_size))

    ! NOTE: does not work
    !self%series = reshape(self%series, (/old_size + new_size/))
    !self%series(old_size+1 : old_size + new_size) = new_data

    ! NOTE: avoid copying and extends array!
    self%series = [self%series, new_data]

    self%series_size = old_size + new_size
  end subroutine

  real(dp) function timeseries_get_average(self, average)
    class(timeseries) :: self
    real(dp), intent(out) :: timeseries_get_average(self%series_size / self%nb_samples)
    integer :: i0, nb_windows

    nb_windows = 0
    average = 0._dp
    do i0 = 1, self%series_size, self%nb_samples
      average(nb_windows) = sum(self%series(i0 : i0 + self%nb_samples)) / (self%nb_samples)
      nb_windows = nb_windows + 1
    end do

    ! average = average / nb_windows
  end subroutine

end module

program main
  use moving_average, only: timeseries, timestats, dp
  implicit none
  type(timestats) :: ts
  integer, parameter :: nb_samples = 6
  real(dp) :: average(nb_samples)

  call ts%init()
  print*, "Initial series data =", ts%series
  print*, "Initial series size =", ts%series_size
  call ts%put_value((/-1._dp, 2._dp, 5._dp, 9._dp, 4._dp/))
  print*, "Updated series data =", ts%series
  print*, "Updated series size =", ts%series_size

  ts%nb_samples = nb_samples
  call ts%get_average(average)
  print*, "Moving average =", average

  call ts%calc_stats()
  print*, "Min =", ts%minimum
  print*, "Min =", ts%maximum
  print*, "Std. dev  =", ts%stddev

end program
