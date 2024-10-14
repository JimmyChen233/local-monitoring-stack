#!/usr/bin/ksh
   for arg in "$@"
   do
    case $arg in
     target=*)
      target="${arg#*=}"
      ;;
    esac
   done
   ping -c 3 $target > /dev/null 2>&1
   exit $?
