#################################################################################
### --------------- Effects of NCAA baseball bat regulations on ------------- ###
### ------------------- offensive performance, 2010--2011 ------------------- ###
#################################################################################

### Package list ----------------------------------------------------------------
library(plyr)
library(reshape2)
library(ggplot2)

### Read in and clean data ------------------------------------------------------

# 2010/2011 offensive data
off.10 <- read.csv("2010_offense.csv", header = TRUE)
off.11 <- read.csv("2011_offense.csv", header = TRUE)

# Split "off.10" data.frame for trend-line graphics
df.10 <- ddply(off.10, .(year, bat, g), summarize, hrs = mean(hr), 
  shs = mean(sh), sbs = mean(sb))
  
# Split "off.11" data.frame for trend-line graphics
df.11 <- ddply(off.11, .(year, bat, g), summarize, hrs = mean(hr), 
  shs = mean(sh), sbs = mean(sb))

# Bind "off.10" and "off.11" data.frames for MANOVA
bat.dat <- rbind(off.10, off.11)

# Split "bat.dat" data.frame for team predictor variable totals
man.dat <- ddply(bat.dat, .(name, year, bat), summarize, hrs = max(hr), 
  shs = max(sh), sbs = max(sb))

# Alternative data.frame from original MANOVA
ncaa.dat <- read.csv("~/Dropbox/NCAA/ncaa_baseball.csv", header = TRUE)

### Data analysis ----------------------------------------------------------------

### Linearity check ###

# Home runs
qplot(sample = hrs, data = man.dat, color = bat) + theme_bw() + 
  scale_color_brewer(palette = "Set1")

# Sacrifice bunts
qplot(sample = shs, data = man.dat, color = bat) + theme_bw() + 
  scale_color_brewer(palette = "Set1")

# Stolen bases
qplot(sample = sbs, data = man.dat, color = bat) + theme_bw() + 
  scale_color_brewer(palette = "Set1")

### Normality check ###

# Home runs
with(man.dat, shapiro.test(hrs))

# Sacrifice bunts
with(man.dat, shapiro.test(shs))

# Stolen bases
with(man.dat, shapiro.test(sbs))

### Multivariate analysis of variance (MANOVA) ###

# Bind variables by column for model inclusion
Y <- with(man.dat, cbind(hrs, shs, sbs))

# MANOVA formula
bat.model <- manova(Y ~ bat, data = man.dat)
summary(bat.model)
summary(bat.model, test = "Wilks")
summary(bat.model, test = "Hotelling-Lawley")

# ANOVA summary for each predictor on outcome
summary.aov(bat.model)

### Post-hoc ANOVAs ###

# Home runs
hr.reg <- lm(hrs ~ bat, data = man.dat)
summary(hr.reg)
confint(hr.reg)
anova(hr.reg)

# Sacrifice bunts
sh.reg <- lm(shs ~ bat, data = man.dat)
summary(sh.reg)
confint(sh.reg)
anova(sh.reg)

# Stolen bases
sb.reg <- lm(sbs ~ bat, data = man.dat)
summary(sb.reg)
confint(sb.reg)
anova(sb.reg)

### Plots ------------------------------------------------------------------------

### Predictor variable boxplots ###

# Home runs
ggplot(data = na.omit(man.dat), aes(x = bat, y = hrs, fill = bat)) + geom_boxplot() +
  scale_fill_manual(breaks = c("BESR (2010)", "BBCOR (2011)"), 
                    values = c("grey", "grey"), name = "Bat Type") +
  scale_x_discrete(labels = c("BESR", "BBCOR") , name = "Bat Type") +
  scale_y_continuous(limits = c(0, 120), breaks = seq(0, 120, 10), 
                     name = "") + 
  ggtitle("Homeruns\n") +
  theme_bw()

# Sacrifice bunts
ggplot(data = na.omit(man.dat), aes(x = bat, y = shs, fill = bat)) + geom_boxplot() +
  scale_fill_manual(breaks = c("BESR (2010)", "BBCOR (2011)"), 
                    values = c("grey", "grey"), name = "Bat Type") +
  scale_x_discrete(labels = c("BESR", "BBCOR") , name = "Bat Type") +
  scale_y_continuous(limits = c(0, 90), breaks = seq(0, 90, 10), 
                     name = "") + 
  ggtitle("Sacrifice Bunts\n") +
  theme_bw()

# Stolen bases
ggplot(data = na.omit(man.dat), aes(x = bat, y = sbs, fill = bat)) + geom_boxplot() +
  scale_fill_manual(breaks = c("BESR (2010)", "BBCOR (2011)"), 
                    values = c("grey", "grey"), name = "Bat Type") +
  scale_x_discrete(labels = c("BESR", "BBCOR") , name = "Bat Type") +
  scale_y_continuous(limits = c(0, 220), breaks = seq(0, 220, 20), 
                     name = "") + 
  ggtitle("Stolen Bases\n") +
  theme_bw()

### Predictor variable trend lines ###

# Home runs
hrs <- ggplot(na.omit(df.10), aes(g)) + 
  geom_line(aes(y = hrs, color = "BESR (2010)")) +
  scale_color_manual(breaks = c("BESR (2010)", "BBCOR (2011)"), 
  values = c("dodgerblue3", "gray25"), name = "Bat Type") +
  scale_x_continuous(limits = c(2, 65), breaks = seq(4, 65, 10), name = "Games") +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 20), name = "Mean HR") + 
  theme_bw()
  hrs <- hrs + geom_line(data = na.omit(df.11), aes(y = hrs, color = "BBCOR (2011)"))
  hrs + ggtitle("Homeruns\n")

# Sacrifice bunts
shs <- ggplot(na.omit(df.10), aes(g)) +
  geom_line(aes(y = shs, color = "BESR (2010)")) +
  scale_color_manual(breaks = c("BESR (2010)", "BBCOR (2011)"), 
  values = c("gray25", "dodgerblue3"), name = "Bat Type") +
  scale_x_continuous(limits = c(2, 65), breaks = seq(4, 64, 10), name = "\nGames") +
  scale_y_continuous(limits = c(0, 40), breaks = seq(0, 40, 10), name = "Mean SH") + 
  theme_bw()
  shs <- shs + geom_line(data = na.omit(df.11), aes(y = shs, color = "BBCOR (2011)"))
  shs + ggtitle("Sacrifice Bunts\n")

# Stolen bases
sbs <- ggplot(na.omit(df.10), aes(g)) +
  geom_line(aes(y = sbs, color = "BESR (2010)")) +
  scale_color_manual(breaks = c("BESR (2010)", "BBCOR (2011)"), 
  values = c("dodgerblue3", "gray25"), name = "Bat Type") +
  scale_x_continuous(limits = c(2, 65), breaks = seq(4, 65, 10), name = "Games") +
  scale_y_continuous(limits = c(0, 95), breaks = seq(0, 90, 20), name = "Mean SB") +
  theme_bw()
  sbs <- sbs + geom_line(data = na.omit(df.11), aes(y = sbs, color = "BBCOR (2011)"))
  sbs + ggtitle("Stolen Bases\n")
