salaries %>% 
  filter(status == 'employee') %>% 
  group_by(year, gender) %>%
  summarize(medianSalary = median(salary)) %>% 
  ggplot(aes(year, medianSalary, color = gender)) +
  geom_line(size = 1.5) +
  scale_x_continuous(breaks = c(2001:as.numeric(format(Sys.Date(), "%Y")))) +
  ggtitle("Median Pay Over Time")

# Measuring the wage gap
wageGap <- salaries %>% 
  group_by(year, president, party, gender) %>% 
  summarize(medianSalary = median(salary)) %>% 
  spread(gender, medianSalary) %>% 
  mutate(wageGap = round(sum(female/male)*100, 2)) %>%
  rename(mensMedianSalary = male,
         womensMedianSalary = female)

wageGap %>% 
  ggplot(aes(year, wageGap)) +
  # geom_line(size = 1.5)
  geom_bar(stat = "identity")

# T.test
salaries %>% 
  filter(status == 'employee') %$% 
  t.test(salary[gender == 'male'], salary[gender == 'female'])

# Old wage gap
wageGap <- salaries %>% 
  group_by(year) %>% 
  summarize(wageGap = 
              round(((median(salary[gender == 'female'])/40) /
                       (median(salary[gender == 'male'])/40) * 100), 2),
            mensMedianSalary = median(salary[gender == 'male']),
            womensMedianSalary = median(salary[gender == 'female']))