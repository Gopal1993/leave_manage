class UserMailer < ApplicationMailer
    def approve_employee_status(employee_mail)
        mail(to: employee_mail, subject: "Employement Approval") 
    end

    def approve_employee_leave(employee_mail,leave_applied_from,leave_applied_to )
      @leave_taken_from = leave_applied_from
      @leave_taken_to = leave_applied_to

        mail(to: employee_mail, subject: "Leave Approval") 
    end
     
    def decline_employee_leave(employee_mail,leave_applied_from,leave_applied_to )
      @leave_taken_from = leave_applied_from
      @leave_taken_to = leave_applied_to

        mail(to: employee_mail, subject: "Leave Declienation") 
    end
end
