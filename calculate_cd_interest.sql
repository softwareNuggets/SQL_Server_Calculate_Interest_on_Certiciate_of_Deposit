create function calculate_cd_interest
(
	@amt_deposit	decimal(10,2),
	@start_date		date,
	@end_date		date,
	@interest_rate	decimal(10,4)
)
RETURNS @table TABLE
(
	amt_deposit	 decimal(10,2),
	term		int,
	rate		decimal(10,4),
	start_date	date,
	end_date	date,
	daily_interest	decimal(14,2),
	annual_interest	decimal(14,2),
	total_interest	decimal(14,2)
)
AS
/*
	history
	---------------------	----------------------------------------
	software nuggets		1/25/2023  - calculate interest on a CD


	--calculate the end date
	select dateAdd(month,24,cast('2023-01-01' as date))

	--execute the function
	select *
	from calculate_cd_interest(100000,'2023-01-01','2024-03-01',0.0425)
*/
BEGIN

	WITH cteDuration as (
		select datediff(month, @start_date, @end_date) as term
	)



	insert into @table
	select
		@amt_deposit,
		cteDuration.term,
		@interest_rate,
		@start_date,
		@end_date,
		(@amt_deposit * (@interest_rate / 365)) AS daily_interest,
		(@amt_deposit * (@interest_rate / 12) * 12) AS annual_interest,
		(@amt_deposit * (@interest_rate / 12) * cteDuration.term) AS total_interest
	from cteDuration;	

	return;
END