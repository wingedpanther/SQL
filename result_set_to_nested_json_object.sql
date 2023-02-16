

SELECT get_freelancer_info('9999999','2022-01-26','2022-03-31');

-- DROP FUNCTION IF EXISTS get_freelancer_info; alter function get_freelancer_info() ...

DELIMITER $$   
CREATE  FUNCTION get_freelancer_info(phone_number VARCHAR(15),start_date DATE, end_date DATE) 
RETURNS JSON 
DETERMINISTIC 
BEGIN 
    -- Created by Vivek on 16th Feb 2022
    DECLARE freelancer_info JSON;
    SELECT JSON_OBJECT(
        'freelancer_id',f.id,
        'username',f.username,
        'fullname',name,
        'email',email,
        'mobile',phone,
        'freelance_sa_certificate_no',freelancer_number,
        'freelance_sa_certified',CASE WHEN is_freelancer_verified = 1 THEN 'verified' ELSE 'unverified' END,
        'total_rating',avg_rate,
        'wallet',wallet,
        'total_jobs_received',freelancer_total_jobs(f.id),
        'total_jobs_completed',freelancer_total_completed(f.id),
        'total_earning',freelancer_total_earning(f.id),
        'freelancer_iban', b.iban_number,
        'totals_on_selected_period',
            (SELECT JSON_OBJECT(
                'first_job_received', MIN(DATE),
                'last_job_received', MAX(DATE),
                'total_jobs_received', COUNT(o.id),
                'total_completed', SUM(CASE WHEN STATUS = 'Completed' THEN 1 ELSE 0 END),
                'average_rating', AVG(ROUND(((r.rate+r.time_rate+r.price_rate)/3))),
                'total_earning', SUM(provider_earning)
            )
            FROM tbl_order_request o
            LEFT JOIN tbl_rate_review r ON o.id = r.order_request_id
            WHERE o.provider_id = f.id AND date BETWEEN start_date AND end_date
            ),
		  'job_details',
		  		(SELECT  json_arrayagg(json_object(
						   'job_id', o.id,
						   'customer_name',u.NAME,
						       'job_start_date',o.DATE,
						       'job_end_date',date(COALESCE(job_end_time,o.DATE)),
						       'job_status',o.STATUS,
						       'rating',COALESCE(ROUND(((r.rate+r.time_rate+r.price_rate)/3)),'no rating'),
						       'review',COALESCE(r.review,'no review'),
							 	'earning',provider_earning
						         )) 
									FROM tbl_order_request o
									INNER JOIN tbl_user u
									ON u.id = o.user_id
									LEFT JOIN tbl_rate_review r ON o.id = r.order_request_id
									WHERE o.provider_id = f.id
									AND o.date BETWEEN start_date AND end_date
  	  		  )
    ) INTO freelancer_info
    FROM tbl_user f
    INNER JOIN tbl_bank b ON f.id = b.provider_id
    WHERE phone = phone_number;
    RETURN freelancer_info;
END $$;
